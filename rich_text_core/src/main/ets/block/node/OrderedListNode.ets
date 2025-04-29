// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node, Range } from "@lark/commonmark"
import { IOLProperty } from "../property/ol/IOLProperty"

export class OrderedListNode extends Node {
  public ol: IOLProperty

  public constructor(ol: IOLProperty, sourceRange?: Range) {
    super(sourceRange)
    this.ol = ol
  }
}
