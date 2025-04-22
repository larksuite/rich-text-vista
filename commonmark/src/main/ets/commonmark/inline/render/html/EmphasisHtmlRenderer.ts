import {HtmlSubRenderer} from "./../../../../render/html/HtmlSubRenderer";
import {HtmlBuilder} from "./../../../../render/html/HtmlBuilder";
import {EmphasisNode} from "./../../node/EmphasisNode";

export class EmphasisHtmlRenderer extends HtmlSubRenderer<EmphasisNode> {
    public constructor () {
        super(EmphasisNode);
    }
    public render (builder : HtmlBuilder, _node : EmphasisNode, entering : boolean) : void {
        builder.tag(entering ? "em" : "/em");
    }
}
