import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {Node} from "./../../../Node";
import {OPENTAG, CLOSETAG} from "./../../common";
import {HtmlBlockNode} from "./../node/HtmlBlockNode";

const reHtmlBlockClose = [
   /./, // dummy for 0
   /<\/(?:script|pre|style)>/i,
   /-->/,
   /\?>/,
   />/,
   /\]\]>/
];


const reHtmlBlockOpen = [
   /./, // dummy for 0
   /^<(?:script|pre|style)(?:\s|>|$)/i,
   /^<!--/,
   /^<[?]/,
   /^<![A-Z]/,
   /^<!\[CDATA\[/,
   /^<[/]?(?:address|article|aside|base|basefont|blockquote|body|caption|center|col|colgroup|dd|details|dialog|dir|div|dl|dt|fieldset|figcaption|figure|footer|form|frame|frameset|h[123456]|head|header|hr|html|iframe|legend|li|link|main|menu|menuitem|meta|nav|noframes|ol|optgroup|option|p|param|section|source|title|summary|table|tbody|td|tfoot|th|thead|title|tr|track|ul)(?:\s|[/]?[>]|$)/i,
    new RegExp('^(?:' + OPENTAG + '|' + CLOSETAG + ')\\s*$', 'i')
];

export class HtmlBlockParser extends BlockParser<HtmlBlockNode> {
    public static readonly START_CHAR = "<";

    public acceptsLines = true;
    public isLeaf = true;

    public constructor (nodeCtor : BlockNodeCtor<HtmlBlockNode> = HtmlBlockNode) {
        super(nodeCtor);
    }

    public tryStart (parser : Parser, node : Node) {
        if (parser.indented) {
            return false;
        }
        //This line isn't really needed but helps with efficiency, I guess
        if (parser.currentLine[parser.nextNonspace] != HtmlBlockParser.START_CHAR) {
            return false;
        }
        const line = parser.currentLine.slice(parser.nextNonspace);
        for (let blockType = 1; blockType <= 7; ++blockType) {
            if (
                reHtmlBlockOpen[blockType].test(line) &&
                (
                    blockType < 7 ||
                    !parser.isParagraphNode(node)
                )
            ) {
                parser.closeUnmatchedBlocks();
                // We don't adjust parser.offset;
                // spaces are part of the HTML block:
                const htmlBlock = parser.addChild<HtmlBlockNode>(this, parser.offset);
                htmlBlock.htmlBlockType = blockType;
                return true;
            }
        }

        return false;

    }
    public continue (parser : Parser, node : HtmlBlockNode) {
        return (
            !parser.blank ||
            (
                node.htmlBlockType != 6 &&
                node.htmlBlockType != 7
            )
        );
    }
    public finalize (_parser : Parser, node : HtmlBlockNode) {
        node.literal = node.stringContent.replace(/(\n *)+$/, '');
    }
    public canContain () { return false; }
    public finalizeAtLine (parser : Parser, node : HtmlBlockNode) {
        return (
            node.htmlBlockType != undefined &&
            node.htmlBlockType >= 1 &&
            node.htmlBlockType <= 5 &&
            reHtmlBlockClose[node.htmlBlockType].test(parser.currentLine.slice(parser.offset))
        );
    }
    public appendString (node : HtmlBlockNode, str : string) : void {
        node.stringContent += str;
    }
    public getString (node : HtmlBlockNode) : string {
        return node.stringContent;
    }
}
