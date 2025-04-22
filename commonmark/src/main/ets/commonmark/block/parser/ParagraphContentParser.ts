import {BlockParser} from "./../../../BlockParser";
import {Node} from "./../../../Node";
import {Parser} from "./../../../Parser";

export abstract class ParagraphContentParser {
    public abstract reinit () : void;
    public abstract parse (paragraphParser : BlockParser<Node>, paragraph : Node, mainParser : Parser) : boolean;
}
