import { BaseVisitHandler, RichTextExtendScope, NodeVisitHandler } from "@im/rich_text_base";
import { TextNodeExtend } from "../extend/text/TextNodeExtend";
import { VisitTextListener } from "./VisitTextListener";
import { NodeWalker } from "@lark/commonmark";
import { StyledTextNode } from "../node/StyledTextNode"

export class TextNodeVisitHandler extends BaseVisitHandler implements NodeVisitHandler<StyledTextNode>, RichTextExtendScope<TextNodeExtend> {
  visitListener?: VisitTextListener

  constructor(visitListener?: VisitTextListener) {
    super()
    this.visitListener = visitListener
  }

  onVisitNode(node: StyledTextNode): void {
    this.visitListener?.start()
    const walker = new NodeWalker(node)
    let data = walker.next()
    while (data) {
      data = walker.next()
    }
    this.visitListener?.end()
  }
}