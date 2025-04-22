import {InlineParser} from "./../../../InlineParser";
import {InlineContentParser} from "./../../../InlineContentParser";
import {Node} from "./../../../Node";
import {ENTITY} from "./../../common";

import {decodeHTML} from "entities";

const reEntityHere = new RegExp('^' + ENTITY, 'i');

export class EntityParser extends InlineParser {
    public parse (parser : InlineContentParser, node : Node) : boolean {
        const c = parser.peek();
        if (c != "&") {
            return false;
        }
        const m = parser.match(reEntityHere);
        if (m == undefined) {
            return false;
        }
        node.appendChild(parser.text(decodeHTML(m)));
        return true;
    }
}
