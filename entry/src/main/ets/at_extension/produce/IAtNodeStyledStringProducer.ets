// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from 'rich_text_core';

export interface IAtNodeStyledStringProducer<T extends Node> {
  produceStyledString(parseContext: T): MutableStyledString;
}