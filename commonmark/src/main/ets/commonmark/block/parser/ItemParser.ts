import {BlockParser, BlockParserMeta, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {Node} from "./../../../Node";
import {isSpaceOrTab, isBlank} from "./../../string-util";

import {ListNode} from "./../node/ListNode";
import {ItemNode} from "./../node/ItemNode";
import {ListData} from "./../node/ListData";

var reBulletListMarker = /^[*+-]/;

var reOrderedListMarker = /^(\d{1,9})([.)])/;

// Parse a list marker and return data on the marker (type,
// start, delimiter, bullet character, padding) or undefined.
function parseListMarker (parser : Parser, node : Node) : ListData|undefined {
    var rest = parser.currentLine.slice(parser.nextNonspace);
    var match;
    var nextc;
    var spacesStartCol;
    var spacesStartOffset;
    var data : ListData & { tight : true } = {
        type: undefined,
        tight: true,  // lists are tight by default
        bulletChar: undefined,
        start: undefined,
        delimiter: undefined,
        padding: undefined,
        markerOffset: parser.indent
    };
    if ((match = rest.match(reBulletListMarker))) {
        data.type = 'bullet';
        data.bulletChar = match[0][0];

    } else if (
        (match = rest.match(reOrderedListMarker)) &&
        (
            !parser.isParagraphNode(node) ||
            match[1] === '1'
        )
    ) {
        data.type = 'ordered';
        data.start = parseInt(match[1]);
        data.delimiter = match[2];
    } else {
        return undefined;
    }
    // make sure we have spaces after
    nextc = parser.currentLine[parser.nextNonspace + match[0].length];
    if (!(nextc == undefined || isSpaceOrTab(nextc))) {
        return undefined;
    }

    // if it interrupts paragraph, make sure first line isn't blank
    if (parser.isParagraphNode(node) && isBlank(parser.currentLine.slice(parser.nextNonspace + match[0].length))) {
        return undefined;
    }

    // we've got a match! advance offset and calculate padding
    parser.advanceNextNonspace(); // to start of marker
    parser.advanceOffset(match[0].length, true); // to end of marker
    spacesStartCol = parser.column;
    spacesStartOffset = parser.offset;
    do {
        parser.advanceOffset(1, true);
        nextc = parser.currentLine[parser.offset];
    } while (parser.column - spacesStartCol < 5 && isSpaceOrTab(nextc));

    var blank_item = (parser.currentLine[parser.offset] == undefined);
    var spaces_after_marker = parser.column - spacesStartCol;
    if (
        spaces_after_marker >= 5 ||
        spaces_after_marker < 1 ||
        blank_item
    ) {
        data.padding = match[0].length + 1;
        parser.column = spacesStartCol;
        parser.offset = spacesStartOffset;
        if (isSpaceOrTab(parser.currentLine[parser.offset])) {
            parser.advanceOffset(1, true);
        }
    } else {
        data.padding = match[0].length + spaces_after_marker;
    }
    return {
        ...data,
        type : data.type,
        padding : data.padding,
    };
};

// Returns true if the two list items are of the same type,
// with the same delimiter and bullet character.  This is used
// in agglomerating list items into lists.
function listsMatch (list_data : ListData, item_data : ListData) {
    return (
        list_data.type === item_data.type &&
        list_data.delimiter === item_data.delimiter &&
        list_data.bulletChar === item_data.bulletChar
    );
};

export class ItemParser extends BlockParser<ItemNode> {
    public acceptsLines = false;
    public endsWithBlankLineIfLastChildEndsWithBlankLine = true;

    private listParser : BlockParser<ListNode>;

    public constructor (listParser : BlockParser<ListNode>, nodeCtor : BlockNodeCtor<ItemNode> = ItemNode) {
        super(nodeCtor);
        this.listParser = listParser;
    }

    public tryStart (parser : Parser, node : Node) {
        if (parser.indented && parser.getBlockParser(node) != this.listParser) {
            return false;
        }
        const data = parseListMarker(parser, node);
        if (data == undefined) {
            return false;
        }
        parser.closeUnmatchedBlocks();

        if (parser.tip == undefined) {
            throw new Error("parser.tip cannot be undefined");
        }

        // add the list if needed
        if (
            !(parser.tip instanceof ListNode) ||
            !(node instanceof ListNode) ||
            !listsMatch(node.listData, data)
        ) {
            const listNode = parser.addChild<ListNode>(this.listParser, parser.nextNonspace);
            listNode.listData = data;
        }

        // add the list item
        const itemNode = parser.addChild<ItemNode>(this, parser.nextNonspace);
        itemNode.listData = data;
        return true;
    };
    public continue (parser : Parser, node : ItemNode) {
        if (parser.blank) {
            if (node.getFirstChild() == undefined) {
                // Blank line after empty list item
                return false;
            } else {
                parser.advanceNextNonspace();
            }
        } else if (
            node.listData.markerOffset != undefined &&
            node.listData.padding != undefined &&
            parser.indent >= (
                node.listData.markerOffset +
                node.listData.padding
            )
       ) {
            parser.advanceOffset(
                node.listData.markerOffset +
                node.listData.padding,
                true
            );
        } else {
            return false;
        }
        return true;
    };
    public finalize () {}
    public canContain (_blockParser : BlockParserMeta, node : Node) : boolean {
        return !(node instanceof ItemNode);
    }
    public canBeContainedBy (_blockParser : BlockParserMeta, node : Node) {
        return node instanceof ListNode;
    }
    public ignoreLastLineBlank (parser : Parser, node : Node) {
        return (
            node.getFirstChild() == undefined &&
            node.sourceRange != undefined &&
            node.sourceRange.start.row === parser.lineNumber
        );
    }
}
