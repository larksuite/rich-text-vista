import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {TextNode} from "./../../../TextNode";


export class TextParser extends BlockParser<TextNode> {
    public acceptsLines = false;
    public isLeaf = true;

    public constructor (nodeCtor : BlockNodeCtor<TextNode> = TextNode) {
        super(nodeCtor);
    }

    public tryStart () {
        return false;
    }
    public continue () : boolean {
        return false;
    };
    public finalize () {}
    public canContain () { return false; }
}
