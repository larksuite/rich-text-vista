import {Parser} from "./Parser";
import {Node, Range} from "./Node";

export type BlockNodeCtor<NodeT extends Node> = {
    new (sourcepos : Range) : NodeT
};

export interface BlockParserMeta {
    canContain       (blockParser : BlockParserMeta, node : Node) : boolean;
    canBeContainedBy (blockParser : BlockParserMeta, node : Node) : boolean;

    acceptsLines : boolean;
    //Has no effect unless acceptsLines is true
    isParagraph? : boolean;

    //If acceptsLines is true, calls appendString, otherwise lazyContinue()
    acceptLazyContinuation? : boolean;

    earlyExitOnEnd? : boolean;
    parseInlines?   : boolean;
    isLeaf?         : boolean;
    endsWithBlankLineIfLastChildEndsWithBlankLine? : boolean;
}

export abstract class BlockParser<NodeT extends Node=Node> implements BlockParserMeta {
    //BEGIN META
    public abstract canContain (blockParser : BlockParserMeta, node : Node) : boolean;
    public canBeContainedBy (_blockParser : BlockParserMeta, _node : Node) : boolean {
        return true;
    }

    public acceptsLines : boolean = false;
    //Has no effect unless acceptsLines is true
    public isParagraph? : boolean;

    //If acceptsLines is true, calls appendString, otherwise lazyContinue()
    public acceptLazyContinuation? : boolean;

    public earlyExitOnEnd? : boolean;
    public parseInlines?   : boolean;
    public isLeaf?         : boolean;
    public endsWithBlankLineIfLastChildEndsWithBlankLine? : boolean;
    //END META

    private readonly nodeCtor : BlockNodeCtor<NodeT>;
    public constructor (nodeCtor : BlockNodeCtor<NodeT>) {
        this.nodeCtor = nodeCtor;
    }

    public isParserOf<OtherT extends Node> (node : OtherT) : this is BlockParser<OtherT> {
        return node instanceof this.nodeCtor;
    }

    public getNodeCtor () : BlockNodeCtor<NodeT> {
        return this.nodeCtor;
    }
    public getName () {
        return this.nodeCtor.name;
    }
    public instantiate (sourceRange : Range) {
        return new this.nodeCtor(sourceRange);
    }

    //Only called if acceptsLines is true
    public appendString (_node : NodeT, _str : string) : void {
        throw new Error(`appendString() not implemented for ${this.getName()}`);
    }

    public getString (_node : NodeT) : string {
        return "";
    }
    public setString (_node : NodeT, _str : string) : void {

    }

    public isActuallyParagraph () {
        return (this.acceptsLines == true && this.isParagraph == true);
    }

    //Called before the parser starts parsing content
    public reinit () {}
    public tryStart (_parser : Parser, _node : Node) : boolean {
        return false;
    }
    public abstract continue (_parser : Parser, _node : NodeT) : boolean;
    public lazyContinue (_parser : Parser, _node : NodeT) : void {

    }
    public finalizeAtLine  (_parser : Parser, _node : NodeT) : boolean {
        return false;
    }
    public abstract finalize (parser : Parser, node : NodeT) : void;
    public ignoreLastLineBlank (_parser : Parser, _node : NodeT) : boolean {
        return false;
    }
};
