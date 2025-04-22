import {HtmlSubRenderer} from "./../../../../render/html/HtmlSubRenderer";
import {HtmlBuilder} from "./../../../../render/html/HtmlBuilder";
import {TextNode} from "./../../../../TextNode";
import {escapeXml} from "./../../../common";

export class TextHtmlRenderer extends HtmlSubRenderer<TextNode> {
    public constructor () {
        super(TextNode);
    }
    public render (builder : HtmlBuilder, node : TextNode, entering : boolean) : void {
        if (entering) {
            builder.append(escapeXml(node.literal, false));
        }
    }
}
