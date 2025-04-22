import {HtmlSubRenderer} from "./../../../../render/html/HtmlSubRenderer";
import {HtmlBuilder} from "./../../../../render/html/HtmlBuilder";
import {ImageNode} from "./../../node/ImageNode";
import {escapeXml} from "./../../../common";

export class ImageHtmlRenderer extends HtmlSubRenderer<ImageNode> {
    public constructor () {
        super(ImageNode);
    }
    public render (builder : HtmlBuilder, node : ImageNode, entering : boolean) : void {
        if (entering) {
            if (builder.tagsAllowed()) {
                builder.append(
                    '<img src="',
                    escapeXml(node.destination, true),
                    '" alt="'
                );
            }
            builder.addDisableTag();
        } else {
            builder.removeDisableTag();
            if (builder.tagsAllowed()) {
                if (node.title) {
                    builder.append('" title="', escapeXml(node.title, true));
                }
                builder.append('" />');
            }
        }
    }
}
