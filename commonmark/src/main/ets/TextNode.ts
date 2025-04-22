import {Node, Range} from "./Node";

//If you want your own custom text node,
//extend this class and pass its ctor to
//InlineContentParser
export class TextNode extends Node {
    public literal : string = "";
    public constructor (strOrRange : string|Range) {
        super(
            (typeof strOrRange == "string") ?
                undefined :
                strOrRange
        );
        if (typeof strOrRange == "string") {
            this.literal = strOrRange;
        }
    }
    public getString () {
        return this.literal;
    }
    public setString (str : string) {
        this.literal = str;
    }
}
