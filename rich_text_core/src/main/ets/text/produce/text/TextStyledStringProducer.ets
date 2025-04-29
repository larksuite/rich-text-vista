// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { TextNodeExtend } from "../../extend/text/TextNodeExtend"
import { assembleText } from "../../string/text/TextStyledString"
import { ITextStyledStringProducer } from "./ITextStyledStringProducer"
import { StyledTextNode } from "../../node/StyledTextNode"
import { BaseProducer } from '../../../base/plugin/ParsePlugin'
import { RichTextExtendScope } from '../../../base/scope/RichTextExtendScope'

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