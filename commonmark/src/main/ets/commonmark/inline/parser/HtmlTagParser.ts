import {InlineParser} from "./../../../InlineParser";
import {InlineContentParser} from "./../../../InlineContentParser";
import {Node} from "./../../../Node";
import {reHtmlTag} from "./../../common";
import {HtmlTagNode} from "./../node/HtmlTagNode";

export class HtmlTagParser extends InlineParser {
    public parse (parser : InlineContentParser, node : Node) : boolean {
        const c = parser.peek();
        if (c != "<") {
            return false;
        }
        const m = parser.match(reHtmlTag);
        if (m == undefined) {
            return false;
        }
        const htmlTag = new HtmlTagNode();
        htmlTag.literal = m;
        node.appendChild(htmlTag);
        return true;
    }
}
