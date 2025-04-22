import { AnchorNode } from "../node/AnchorNode"
import { BaseProducer, RichTextExtendScope } from "@im/rich_text_base"
import { assembleAnchor } from "../string/AnchorStyledString"
import { AnchorNodeExtend } from "../extend/AnchorNodeExtend"
import { IAnchorStyledStringProducer } from "./AnchorNodeStyledStringProducer"

export class AnchorStyledStringProducer extends BaseProducer implements IAnchorStyledStringProducer<AnchorNode>, RichTextExtendScope<AnchorNodeExtend> {
  produceStyledString(
    parseContext: AnchorNode,
    fontSize: number,
    fontColor: ResourceColor | undefined,
    uniqueId: number | undefined,
    openAnchor: () => void,
    onAnchorClick: () => void
  ): MutableStyledString {
    const anchorStyledString = new MutableStyledString("")
    assembleAnchor(parseContext.anchor, anchorStyledString, fontSize, fontColor, uniqueId, openAnchor, onAnchorClick)
    return anchorStyledString
  }
}