import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {ThematicBreakNode} from "./../node/ThematicBreakNode";

const reThematicBreak = /^(?:(?:\*[ \t]*){3,}|(?:_[ \t]*){3,}|(?:-[ \t]*){3,})[ \t]*$/;

export class ThematicBreakParser extends BlockParser<ThematicBreakNode> {
    public acceptsLines = false;
    public isLeaf = true;

    public constructor (nodeCtor : BlockNodeCtor<ThematicBreakNode> = ThematicBreakNode) {
        super(nodeCtor);
    }

    public tryStart (parser : Parser) {
        if (parser.indented) {
            return false;
        }
        if (!reThematicBreak.test(parser.currentLine.slice(parser.nextNonspace))) {
            return false;
        }
        parser.closeUnmatchedBlocks();
        parser.addChild(this, parser.nextNonspace);
        parser.advanceOffset(parser.currentLine.length - parser.offset, false);
        return true;
    }
    public continue () : boolean {
        // a thematic break can never container > 1 line, so fail to match:
        return false;
    };
    public finalize () {}
    public canContain () { return false; }
}
