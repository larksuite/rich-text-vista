import {BlockParser, BlockParserMeta, BlockNodeCtor} from "./../../../BlockParser";
import {Parser} from "./../../../Parser";
import {ItemNode} from "./../node/ItemNode";
import {ListNode} from "./../node/ListNode";
import {Node} from "./../../../Node";

export class ListParser extends BlockParser<ListNode> {
    public acceptsLines = false;
    public endsWithBlankLineIfLastChildEndsWithBlankLine = true;

    public constructor (nodeCtor : BlockNodeCtor<ListNode> = ListNode) {
        super(nodeCtor);
    }

    public continue () { return true; }
    public finalize (parser : Parser, node : ListNode) {
        let item = node.getFirstChild();
        while (item != null) {
            // check for non-final list item ending with blank line:
            if (parser.endsWithBlankLine(item) && item.getNext()) {
                node.listData.tight = false;
                break;
            }
            // recurse into children of list item, to see if there are
            // spaces between any of them:
            let subitem = item.getFirstChild();
            while (subitem != null) {
                if (
                    parser.endsWithBlankLine(subitem) &&
                    (
                        item.getNext() ||
                        subitem.getNext()
                    )
                ) {
                    node.listData.tight = false;
                    break;
                }
                subitem = subitem.getNext();
            }
            item = item.getNext();
        }
        if (node.listData.tight) {
            //Remove all paragraph elements
            for (let item = node.getFirstChild(); item != undefined; item = item.getNext()) {
                for (let paragraph = item.getFirstChild(); paragraph != undefined; paragraph = paragraph.getNext()) {
                    if (parser.isParagraphNode(paragraph)) {
                        //Move all its children to item, unlink paragraph
                        parser.inlineContentParser.parse(parser, parser.getBlockParsers().getParagraphParser(), paragraph);
                        let cur = paragraph.getFirstChild();
                        while (cur != undefined) {
                            let nxt = cur.getNext();

                            paragraph.insertBefore(cur);

                            cur = nxt;
                        }
                        paragraph.unlink();
                    }
                }
            }
        }
    }
    public canContain (_blockParser : BlockParserMeta, node : Node) {
        return node instanceof ItemNode;
    }
}
