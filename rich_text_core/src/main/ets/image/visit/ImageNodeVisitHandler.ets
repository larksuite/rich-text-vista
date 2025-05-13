// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { BaseVisitHandler } from "../../base/plugin/ParsePlugin"
import { RichTextExtendScope } from "../../base/scope/RichTextExtendScope"
import { NodeVisitHandler } from "../../base/visit/NodeVisitHandler"
import { ImageNodeExtend } from "../extend/ImageNodeExtend"
import { StyledImageNode } from "../node/StyledImageNode"
import { VisitImageListener } from "./VisitImageListener"
import { NodeWalker } from "commonmark"

export class ImageNodeVisitHandler extends BaseVisitHandler implements NodeVisitHandler<StyledImageNode>, RichTextExtendScope<ImageNodeExtend> {
  visitListener?: VisitImageListener

  constructor(visitListener?: VisitImageListener) {
    super()
    this.visitListener = visitListener
  }

  onVisitNode(node: StyledImageNode): void {
    this.visitListener?.start()
    const walker = new NodeWalker(node)
    let data = walker.next()
    while (data) {
      data = walker.next()
    }
    this.visitListener?.end()
  }
}