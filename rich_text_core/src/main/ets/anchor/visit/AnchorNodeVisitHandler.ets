// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { AnchorNode } from "../node/AnchorNode";
import { NodeVisitHandler } from "../../base/visit/NodeVisitHandler";
import { BaseVisitHandler } from "../../base/plugin/ParsePlugin";
import { RichTextExtendScope } from "../../base/scope/RichTextExtendScope";
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