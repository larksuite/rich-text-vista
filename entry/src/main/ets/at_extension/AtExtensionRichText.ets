// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { IExtensionRichText, Node } from "rich_text_core";
import { AtNode } from "./node/AtNode";
import { AtStyledStringProducer } from "./produce/AtStyledStringProducer";

export class AtExtensionRichText implements IExtensionRichText<AtNode> {
  produceMutableStyledString(node: Node): MutableStyledString | undefined{
    if (node instanceof AtNode) {
      const producer = new AtStyledStringProducer()
      return producer.produceStyledString(node)
    } else {
      return undefined
    }
  }
}