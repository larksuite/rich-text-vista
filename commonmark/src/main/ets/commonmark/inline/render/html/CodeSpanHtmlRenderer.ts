import {HtmlSubRenderer} from "./../../../../render/html/HtmlSubRenderer";
import {HtmlBuilder} from "./../../../../render/html/HtmlBuilder";
import {CodeSpanNode} from "./../../node/CodeSpanNode";
import {escapeXml} from "./../../../common";

export class CodeSpanHtmlRenderer extends HtmlSubRenderer<CodeSpanNode> {
    public constructor () {
        super(CodeSpanNode);
    }
    public render (builder : HtmlBuilder, node : CodeSpanNode, entering : boolean) : void {
        if (entering) {
            builder
                .tag("code")
                .append(escapeXml(node.literal, false))
                .tag("/code");
        }
    }
}
