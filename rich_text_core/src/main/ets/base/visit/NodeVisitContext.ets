// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from 'commonmark';
import { NodeParseContext } from '../parse/NodeParseContext';

export interface NodeVisitContext<T extends Node> extends NodeParseContext<T> {}