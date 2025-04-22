import {InlineParser} from "./../../../InlineParser";
import {InlineContentParser} from "./../../../InlineContentParser";
import {Node} from "./../../../Node";
import {CodeSpanNode} from "./../node/CodeSpanNode";

const reTicks = /`+/;

const reTicksHere = /^`+/;

const reWhitespace = /[ \t\n\x0b\x0c\x0d]+/g;


export class CodeSpanParser extends InlineParser {
    // All of the parsers below try to match something at the current position
    // in the subject.  If they succeed in matching anything, they
    // return the inline matched, advancing the subject.

    // Attempt to parse backticks, adding either a backtick code span or a
    // literal sequence of backticks.
    public parse (parser : InlineContentParser, node : Node) : boolean {
        const c = parser.peek();
        if (c != "`") {
            return false;
        }
        const ticks = parser.match(reTicksHere);
        if (ticks == undefined) {
            return false;
        }
        const afterOpenTicks = parser.pos;
        let matched = parser.match(reTicks);
        while (matched != undefined) {
            if (matched == ticks) {
                const codeSpan = new CodeSpanNode();
                codeSpan.literal = parser.subject.slice(
                    afterOpenTicks,
                    parser.pos - ticks.length
                )
                    .trim()
                    .replace(reWhitespace, " ");
                node.appendChild(codeSpan);
                return true;
            }
            matched = parser.match(reTicks);
        }
        // If we got here, we didn't match a closing backtick sequence.
        parser.pos = afterOpenTicks;
        node.appendChild(parser.text(ticks));
        return true;
    }
}
