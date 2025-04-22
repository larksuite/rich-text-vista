import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {isSpaceOrTab} from "./../../string-util";
import {BlockquoteNode} from "./../node/BlockquoteNode";

export class BlockquoteParser extends BlockParser<BlockquoteNode> {
    public static readonly START_CHAR = ">";

    public acceptsLines = false;

    public constructor (nodeCtor : BlockNodeCtor<BlockquoteNode> = BlockquoteNode) {
        super(nodeCtor);
    }

    public tryStart (parser : Parser) {
        if (parser.indented) {
            return false;
        }
        if (parser.currentLine[parser.nextNonspace] != BlockquoteParser.START_CHAR) {
            return false;
        }
        parser.advanceNextNonspace();
        parser.advanceOffset(1, false);
        // optional following space
        if (isSpaceOrTab(parser.currentLine[parser.offset])) {
            parser.advanceOffset(1, true);
        }
        parser.closeUnmatchedBlocks();
        parser.addChild(this, parser.nextNonspace);
        return true;
    }
    public continue (parser : Parser) {
        if (parser.indented) {
            return false;
        }
        if (parser.currentLine[parser.nextNonspace] != BlockquoteParser.START_CHAR) {
            return false;
        }
        parser.advanceNextNonspace();
        parser.advanceOffset(1, false);
        if (isSpaceOrTab(parser.currentLine[parser.offset])) {
            parser.advanceOffset(1, true);
        }
        return true;
    }
    public finalize () {}
    public canContain () { return true; }
    public ignoreLastLineBlank () {
        return true;
    }
}
