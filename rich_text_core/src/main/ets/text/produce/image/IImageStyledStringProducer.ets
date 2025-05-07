// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from 'commonmark';

export interface IImageStyledStringProducer<T extends Node> {
  produceStyledString(
    parseContext: T,
    width: number | undefined,
    height: number | undefined,
  ): MutableStyledString
}