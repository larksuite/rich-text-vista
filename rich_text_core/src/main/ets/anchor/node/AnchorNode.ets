// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { IAnchorProperty } from '../property/IAnchorProperty';
import { Node, Range } from 'commonmark';

export class AnchorNode extends Node {
  public anchor: IAnchorProperty

  public constructor(anchor: IAnchorProperty, sourceRange?: Range) {
    super(sourceRange)
    this.anchor = anchor
  }
}