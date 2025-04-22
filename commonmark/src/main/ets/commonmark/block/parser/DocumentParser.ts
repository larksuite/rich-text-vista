import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {DocumentNode} from "./../node/DocumentNode";

export class DocumentParser extends BlockParser<DocumentNode> {
    public acceptsLines = false;

    public constructor (nodeCtor : BlockNodeCtor<DocumentNode> = DocumentNode) {
        super(nodeCtor);
    }

    public continue () { return true; }
    public finalize () {}
    public canContain () { return true; }
}
