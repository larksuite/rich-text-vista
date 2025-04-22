import {HtmlSubRenderer} from "./../../../../render/html/HtmlSubRenderer";
import {HtmlBuilder} from "./../../../../render/html/HtmlBuilder";
import {LinkNode} from "./../../node/LinkNode";
import {escapeXml} from "./../../../common";

export class LinkHtmlRenderer extends HtmlSubRenderer<LinkNode> {
    public constructor () {
        super(LinkNode);
    }
    public render (builder : HtmlBuilder, node : LinkNode, entering : boolean) : void {
        if (entering) {
            const attrs : [string, string][] = [];
            attrs.push(['href', escapeXml(node.destination, true)]);
            if (node.title) {
                attrs.push(['title', escapeXml(node.title, true)]);
            }
            builder.tag('a', attrs);
        } else {
            builder.tag('/a');
        }
    }
}
