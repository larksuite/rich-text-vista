import {InlineParser} from "./../../../InlineParser";
import {InlineContentParser} from "./../../../InlineContentParser";
import {Node} from "./../../../Node";
import {HardbreakNode} from "./../node/HardbreakNode";
import {SoftbreakNode} from "./../node/SoftbreakNode";

const reFinalSpace = / *$/;

const reInitialSpace = /^ */;

export class NewlineParser extends InlineParser {
    public parse (parser : InlineContentParser, node : Node) : boolean {
        const c = parser.peek();
        if (c != "\n") {
            return false;
        }
        ++parser.pos;

        // check previous node for trailing spaces
        const lastc = node.getLastChild();
        if (
            lastc != undefined &&
            parser.isTextNode(lastc) &&
            lastc.getString()[lastc.getString().length - 1] === " "
        ) {
            const isHardbreak = lastc.getString()[lastc.getString().length - 2] === " ";
            lastc.setString(lastc.getString().replace(reFinalSpace, ""));
            if (isHardbreak) {
                node.appendChild(new HardbreakNode());
            } else {
                node.appendChild(new SoftbreakNode());
            }
        } else {
            node.appendChild(new SoftbreakNode());
        }
        parser.match(reInitialSpace); // gobble leading spaces in next line
        return true;
    }
}
