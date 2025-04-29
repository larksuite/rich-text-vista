// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { TextNodeExtend } from "../extend/text/TextNodeExtend"
import { VisitTextListener } from "./VisitTextListener"
import { NodeWalker } from "@lark/commonmark"
import { StyledTextNode } from "../node/StyledTextNode"
import { BaseVisitHandler } from "../../base/plugin/ParsePlugin"
import { RichTextExtendScope } from "../../base/scope/RichTextExtendScope"
import { NodeVisitHandler } from "../../base/visit/NodeVisitHandler"

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