// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { AtNode } from "../node/AtNode";
import { BaseProducer, RichTextExtendScope } from "rich_text_core";
import { assembleAt } from "../assemble/AtStyledString";
import { AtNodeExtend } from "../extend/AtNodeExtend";
import { IAtNodeStyledStringProducer } from "../produce/IAtNodeStyledStringProducer";

export class AtStyledStringProducer extends BaseProducer implements IAtNodeStyledStringProducer<AtNode>, RichTextExtendScope<AtNodeExtend> {
  produceStyledString(parseContext: AtNode): MutableStyledString {
    const atStyledString = new MutableStyledString("")
    assembleAt(parseContext, atStyledString)
    return atStyledString
  }
}