import {BlockParser, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {isBlank} from "./../../string-util";
import {ParagraphNode} from "./../node/ParagraphNode";
import {ParagraphContentParser} from "./ParagraphContentParser";

export class ParagraphParser extends BlockParser<ParagraphNode> {
    public acceptsLines = true;
    public parseInlines = true;
    public acceptLazyContinuation = true;
    public isLeaf = true;
    public isParagraph = true;

    private contentParsers : ParagraphContentParser[];

    public constructor (contentParsers : ParagraphContentParser[], nodeCtor : BlockNodeCtor<ParagraphNode> = ParagraphNode) {
        super(nodeCtor);
        this.contentParsers = contentParsers;
    }

    public reinit () {
        for (let p of this.contentParsers) {
            p.reinit();
        }
    }
    public continue (parser : Parser) {
        return parser.blank ? false : true;
    }
    public finalize (parser : Parser, node : ParagraphNode) {
        let parsed = true;
        while (parsed) {
            parsed = false;
            for (let p of this.contentParsers) {
                if (p.parse(this, node, parser)) {
                    parsed = true;
                    break;
                }
            }
        }
        if (isBlank(node.stringContent)) {
            node.unlink();
        }
    };
    public canContain () { return false; }
    public appendString (node : ParagraphNode, str : string) : void {
        if (node.stringContent == undefined) {
            node.stringContent = "";
        }
        node.stringContent += str;
    }
    public setString (node : ParagraphNode, str : string) : void {
        node.stringContent = str;
    }
    public getString (node : ParagraphNode) : string {
        return node.stringContent;
    }
}
