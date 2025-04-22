import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {IndentedCodeBlockNode} from "./../node/IndentedCodeBlockNode";

export class IndentedCodeBlockParser extends BlockParser<IndentedCodeBlockNode> {
    public acceptsLines = true;
    public isLeaf = true;

    public constructor (nodeCtor : BlockNodeCtor<IndentedCodeBlockNode> = IndentedCodeBlockNode) {
        super(nodeCtor);
    }

    public tryStart (parser : Parser) {
        if (!parser.indented) {
            return false;
        }
        if (parser.blank) {
            return false;
        }
        if (parser.tip == undefined || parser.isParagraphNode(parser.tip)) {
            return false;
        }
        parser.advanceOffset(parser.indentLength, true);
        parser.closeUnmatchedBlocks();
        parser.addChild(this, parser.offset);
        return true;
    }
    public continue (parser : Parser) {
        const indent = parser.indent;
        if (indent >= parser.indentLength) {
            parser.advanceOffset(parser.indentLength, true);
            return true;
        } else if (parser.blank) {
            parser.advanceNextNonspace();
            return true;
        } else {
            return false;
        }
    }
    public finalize (_parser : Parser, node : IndentedCodeBlockNode) {
        node.literal = node.stringContent.replace(/(\n *)+$/, '\n');
    }
    public canContain () { return false; }

    public appendString (node : IndentedCodeBlockNode, str : string) : void {
        if (node.stringContent == undefined) {
            node.stringContent = "";
        }
        node.stringContent += str;
    }
    public getString (node : IndentedCodeBlockNode) : string {
        return node.stringContent;
    }
}
