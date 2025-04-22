import {HtmlSubRenderer} from "./../../../../render/html/HtmlSubRenderer";
import {HtmlBuilder} from "./../../../../render/html/HtmlBuilder";
import {StrongNode} from "./../../node/StrongNode";

export class StrongHtmlRenderer extends HtmlSubRenderer<StrongNode> {
    public constructor () {
        super(StrongNode);
    }
    public render (builder : HtmlBuilder, _node : StrongNode, entering : boolean) : void {
        builder.tag(entering ? "strong" : "/strong");
    }
}
