import {BlockParser} from "./BlockParser";
import {Node, Range} from "./Node";

export class BlockParserCollection<DocumentT extends Node=Node, ParagraphT extends Node=Node> {
    private documentParser  : BlockParser<DocumentT>;
    private paragraphParser : BlockParser<ParagraphT>;

    private arr : BlockParser[] = [];

    public constructor (documentParser : BlockParser<DocumentT>, paragraphParser : BlockParser<ParagraphT>) {
        if (!paragraphParser.isActuallyParagraph()) {
            throw new Error(`Paragraph parser must accept lines and be a paragraph`);
        }
        this.documentParser  = documentParser;
        this.paragraphParser = paragraphParser;

        this.arr.push(documentParser);
        this.arr.push(paragraphParser);
    }

    public getDocumentParser () {
        return this.documentParser;
    }
    public getParagraphParser () {
        return this.paragraphParser;
    }
    public add (parser : BlockParser) : this {
        this.arr.push(parser);
        return this;
    }
    public has (key : Node) : boolean {
        for (let i of this.arr) {
            if (i.isParserOf(key)) {
                return true;
            }
        }
        return false;
    }
    public get<NodeT extends Node> (key : NodeT) : BlockParser<NodeT> {
        for (let i of this.arr) {
            if (i.isParserOf(key)) {
                return i;
            }
        }
        throw new Error(`No parser found for node ${Object.getPrototypeOf(key).constructor.name}`);
    }
    public length () {
        return this.arr.length;
    }
    public at (index : number) : BlockParser<Node> {
        return this.arr[index];
    }
    public isParagraphNode (node : Node) : node is ParagraphT {
        return (
            Object.getPrototypeOf(node).constructor ==
            this.getParagraphParser().getNodeCtor()
        );
    }
    public instantiateDocument (sourcepos : Range) : DocumentT {
        const ctor = this.getDocumentParser().getNodeCtor();
        return new ctor(sourcepos);
    }
    public instantiateParagraph (sourcepos : Range) : ParagraphT {
        const ctor = this.getParagraphParser().getNodeCtor();
        return new ctor(sourcepos);
    }
    public reinit () {
        this.documentParser.reinit();
        this.paragraphParser.reinit();
        for (let b of this.arr) {
            b.reinit();
        }
    }
}
