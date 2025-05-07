// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { BaseParseContext } from './BaseParseContext';
import { Node } from 'commonmark';

export interface NodeParseContext<T extends Node> extends BaseParseContext {
  readonly node: T
}