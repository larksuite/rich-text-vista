import { AnchorNode } from "../node/AnchorNode";
import { BaseVisitHandler, NodeVisitHandler, RichTextExtendScope } from "@im/rich_text_base";
import { NodeWalker } from "@lark/commonmark";
import { AnchorNodeExtend } from "../extend/AnchorNodeExtend";
import { VisitAnchorListener } from "./VisitAnchorListener";

export class AnchorNodeVisitHandler extends BaseVisitHandler implements NodeVisitHandler<AnchorNode>, RichTextExtendScope<AnchorNodeExtend> {
  visitListener?: VisitAnchorListener

  constructor(visitListener?: VisitAnchorListener) {
    super()
    this.visitListener = visitListener
  }

  onVisitNode(node: AnchorNode): void {
    this.visitListener?.start()
    const walker = new NodeWalker(node)
    let data = walker.next()
    while (data) {
      data = walker.next()
    }
    this.visitListener?.end()
  }
}