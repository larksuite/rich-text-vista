import { BaseProducer, RichTextExtendScope } from "@im/rich_text_base";
import { TextNodeExtend } from "../../extend/text/TextNodeExtend";
import { assembleText } from "../../string/text/TextStyledString";
import { ITextStyledStringProducer } from "./ITextStyledStringProducer";
import { StyledTextNode } from "../../node/StyledTextNode"

export class TextStyledStringProducer extends BaseProducer implements ITextStyledStringProducer<StyledTextNode>, RichTextExtendScope<TextNodeExtend> {
  produceStyledString(
    parseContext: StyledTextNode,
    fontSize: number
  ): MutableStyledString {
    const textStyledString = new MutableStyledString("")
    assembleText(parseContext.text.content, textStyledString, fontSize, parseContext.attributes)
    return textStyledString
  }
}