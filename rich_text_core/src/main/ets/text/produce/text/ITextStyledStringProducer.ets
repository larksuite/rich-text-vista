// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from '@lark/commonmark';

export interface ITextStyledStringProducer<T extends Node> {
  produceStyledString(
    parseContext: T,
    fontSize: number,
    styles?: Map<string, string>
  ): MutableStyledString
}