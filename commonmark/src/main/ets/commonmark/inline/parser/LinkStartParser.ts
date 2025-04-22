import {InlineParser} from "./../../../InlineParser";
import {InlineContentParser} from "./../../../InlineContentParser";
import {Node} from "./../../../Node";
import {BracketCollection} from "./BracketCollection";

export class LinkStartParser extends InlineParser {
    private brackets : BracketCollection;
    public constructor (brackets : BracketCollection) {
        super();
        this.brackets = brackets;
    }
    public reinit () {
        this.brackets.clear();
    }
    // Add open bracket to delimiter stack and add a text node to block's children.
    public parse (parser : InlineContentParser, node : Node) : boolean {
        const c = parser.peek();
        if (c != "[") {
            return false;
        }
        const startpos = parser.pos;
        parser.pos += 1;

        const text = parser.text('[');
        node.appendChild(text);

        // Add entry to stack for this opener
        this.brackets.push(text, startpos, false);
        return true;
    }
}
