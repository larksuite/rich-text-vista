import {HtmlSubRenderer} from "./../../../../render/html/HtmlSubRenderer";
import {HtmlBuilder} from "./../../../../render/html/HtmlBuilder";
import {HardbreakNode} from "./../../node/HardbreakNode";

export class HardbreakHtmlRenderer extends HtmlSubRenderer<HardbreakNode> {
    public constructor () {
        super(HardbreakNode);
    }
    public render (builder : HtmlBuilder, _node : HardbreakNode, entering : boolean) : void {
        if (entering) {
            builder
                .tag("br", undefined, true)
                .nl();
        }
    }
}
