import {HtmlSubRenderer} from "./../../../../render/html/HtmlSubRenderer";
import {HtmlBuilder} from "./../../../../render/html/HtmlBuilder";
import {SoftbreakNode} from "./../../node/SoftbreakNode";

export class SoftbreakHtmlRenderer extends HtmlSubRenderer<SoftbreakNode> {
    public constructor () {
        super(SoftbreakNode);
    }
    public render (builder : HtmlBuilder, _node : SoftbreakNode, entering : boolean) : void {
        if (entering) {
            builder.append("\n");
        }
    }
}
