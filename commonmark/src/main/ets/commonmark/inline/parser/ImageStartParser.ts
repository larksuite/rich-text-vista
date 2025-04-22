import {InlineParser} from "./../../../InlineParser";
import {InlineContentParser} from "./../../../InlineContentParser";
import {Node} from "./../../../Node";
import {BracketCollection} from "./BracketCollection";

export class ImageStartParser extends InlineParser {
    private brackets : BracketCollection;
    public constructor (brackets : BracketCollection) {
        super();
        this.brackets = brackets;
    }
    public parse (parser : InlineContentParser, node : Node) : boolean {
        const c = parser.peek();
        if (c != "!") {
            return false;
        }
        const startpos = parser.pos;
        ++parser.pos;
        if (parser.peek() != "[") {
            --parser.pos;
            return false;
        }
        ++parser.pos;

        const text = parser.text('![');
        node.appendChild(text);

        // Add entry to stack for this opener
        this.brackets.push(text, startpos + 1, true);
        return true;
    }
}
