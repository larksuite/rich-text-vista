import {Node} from "./Node";
import {InlineContentParser} from "./InlineContentParser";
import {BlockParser} from "./BlockParser";
import {Parser} from "./Parser";

export abstract class InlineParser {
    public reinitForDocument () : void {}
    public reinit () : void {}
    public abstract parse (inlineContentParser : InlineContentParser, node : Node, blockParser : BlockParser, mainParser : Parser) : boolean;
    public finalize () : void {}
}
