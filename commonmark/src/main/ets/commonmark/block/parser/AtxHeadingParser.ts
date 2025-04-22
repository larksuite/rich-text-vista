import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {HeadingNode} from "./../node/HeadingNode";

const reATXHeadingMarker = /^#{1,6}(?:[ \t]+|$)/;

export class AtxHeadingParser extends BlockParser<HeadingNode> {
    public acceptsLines = false;
    public parseInlines = true;
    public isLeaf = true;

    public constructor (nodeCtor : BlockNodeCtor<HeadingNode> = HeadingNode) {
        super(nodeCtor);
    }

    public tryStart (parser : Parser) {
        if (parser.indented) {
            return false;
        }
        const match = parser.currentLine.slice(parser.nextNonspace).match(reATXHeadingMarker);
        if (match == null) {
            return false;
        }
        parser.advanceNextNonspace();
        parser.advanceOffset(match[0].length, false);
        parser.closeUnmatchedBlocks();
        const heading : HeadingNode = parser.addChild<HeadingNode>(this, parser.nextNonspace);
        heading.level = match[0].trim().length; // number of #s
        // remove trailing ###s:
        heading.stringContent = parser.currentLine
            .slice(parser.offset)
            .replace(/^[ \t]*#+[ \t]*$/, "")
            .replace(/[ \t]+#+[ \t]*$/, "");
        parser.advanceOffset(parser.currentLine.length - parser.offset);
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
