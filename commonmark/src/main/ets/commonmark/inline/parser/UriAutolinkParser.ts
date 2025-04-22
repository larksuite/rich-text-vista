import {InlineParser} from "./../../../InlineParser";
import {InlineContentParser} from "./../../../InlineContentParser";
import {Node} from "./../../../Node";
import {normalizeURI} from "./../../common";
import {LinkNode} from "./../node/LinkNode";

const reAutolink = /^<[A-Za-z][A-Za-z0-9.+-]{1,31}:[^<>\x00-\x20]*>/i;

export class UriAutolinkParser extends InlineParser {
    // Attempt to parse an autolink (URL or email in pointy brackets).
    public parse (parser : InlineContentParser, node : Node) : boolean {
        if (parser.peek() != "<") {
            return false;
        }
        const m = parser.match(reAutolink);
        if (m == undefined) {
            return false;
        }
        const dest = m.slice(1, m.length - 1);
        const link = new LinkNode();
        link.destination = normalizeURI(dest);
        link.title = '';
        link.appendChild(parser.text(dest));
        node.appendChild(link);
        return true;
    }
}
