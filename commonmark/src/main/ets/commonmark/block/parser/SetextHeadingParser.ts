import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {Node} from "./../../../Node";
import {HeadingNode} from "./../node/HeadingNode";

const reSetextHeadingLine = /^(?:=+|-+)[ \t]*$/;

export class SetextHeadingParser extends BlockParser<HeadingNode> {
    public acceptsLines = false;
    public parseInlines = true;
    public isLeaf = true;

    public constructor (nodeCtor : BlockNodeCtor<HeadingNode> = HeadingNode) {
        super(nodeCtor);
    }

    public tryStart (parser : Parser, node : Node) {
        if (parser.indented) {
            return false;
        }
        if (!parser.isParagraphNode(node)) {
            return false;
        }

        const match = parser.currentLine
            .slice(parser.nextNonspace)
            .match(reSetextHeadingLine);
        if (match == null) {
            return false;
        }
        parser.closeUnmatchedBlocks();
        if (node.sourceRange == undefined) {
            throw new Error("sourceRange cannot be undefined")
        }
        const heading = this.instantiate(node.sourceRange);
        heading.level = (match[0][0] === "=") ?
            1 : 2;
        heading.stringContent = parser.getBlockParsers().getParagraphParser().getString(node);
        node.insertAfter(heading);
        node.unlink();
        parser.tip = heading;
        parser.advanceOffset(parser.currentLine.length - parser.offset, false);
        return true;
    }
    public continue () {
        // a heading can never container > 1 line, so fail to match:
        return false;
    }
    public finalize () {}
    public canContain () { return false; }

    public getString (node : HeadingNode) : string {
        return node.stringContent;
    }
}
