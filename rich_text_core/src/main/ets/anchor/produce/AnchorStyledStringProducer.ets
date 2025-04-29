// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { AnchorNode } from "../node/AnchorNode"
import { BaseProducer } from "../../base/plugin/ParsePlugin"
import { RichTextExtendScope } from "../../base/scope/RichTextExtendScope"
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