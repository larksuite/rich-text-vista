import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {isSpaceOrTab} from "./../../string-util";
import {unescapeString} from "./../../common";
import {FencedCodeBlockNode} from "./../node/FencedCodeBlockNode";

const reCodeFence = /^`{3,}(?!.*`)|^~{3,}(?!.*~)/;

const reClosingCodeFence = /^(?:`{3,}|~{3,})(?= *$)/;

export class FencedCodeBlockParser extends BlockParser<FencedCodeBlockNode> {
    public acceptsLines = true;
    public earlyExitOnEnd = true;
    public isLeaf = true;

    public constructor (nodeCtor : BlockNodeCtor<FencedCodeBlockNode> = FencedCodeBlockNode) {
        super(nodeCtor);
    }

    public tryStart (parser : Parser) {
        if (parser.indented) {
            return false;
        }
        const match = parser.currentLine
            .slice(parser.nextNonspace)
            .match(reCodeFence);
        if (match == null) {
            return false;
        }
        const fenceLength = match[0].length;
        parser.closeUnmatchedBlocks();
        const fencedCodeBlock = parser.addChild<FencedCodeBlockNode>(this, parser.nextNonspace);
        fencedCodeBlock.fenceLength = fenceLength;
        fencedCodeBlock.fenceChar = match[0][0];
        fencedCodeBlock.fenceOffset = parser.indent;
        parser.advanceNextNonspace();
        parser.advanceOffset(fenceLength, false);
        return true;
    }
    public continue (parser : Parser, node : FencedCodeBlockNode) {
        const ln = parser.currentLine;
        if (
            !parser.indented &&
            ln.charAt(parser.nextNonspace) === node.fenceChar
        ) {
            const match = ln.slice(parser.nextNonspace).match(reClosingCodeFence);
            if (match != undefined && match[0].length >= node.fenceLength) {
                // closing fence - we're at end of line, so we can return
                parser.finalize(node, parser.lineNumber);
                return false;
            }
        }

        // skip optional spaces of fence offset
        for (let i=node.fenceOffset; i > 0 && isSpaceOrTab(ln[parser.offset]); --i) {
            parser.advanceOffset(1, true);
        }
        return true;
    }
    public finalize (_parser : Parser, node : FencedCodeBlockNode) {
        // first line becomes info string
        const content = node.stringContent;
        if (content == undefined) {
            throw new Error("content cannot be undefined");
        }
        const newlinePos = content.indexOf('\n');
        const firstLine = content.slice(0, newlinePos);
        const rest = content.slice(newlinePos + 1);
        node.info = unescapeString(firstLine.trim());
        node.literal = rest;
    }
    public canContain () { return false; }
    public ignoreLastLineBlank () {
        return true;
    }
    public appendString (node : FencedCodeBlockNode, str : string) : void {
        node.stringContent += str;
    }
    public getString (node : FencedCodeBlockNode) : string {
        return node.stringContent;
    }
}
