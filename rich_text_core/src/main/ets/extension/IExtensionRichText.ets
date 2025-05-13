// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from '../base/node/Node'

export interface IExtensionRichText<T extends Node> {
  produceMutableStyledString: (node: T) => MutableStyledString | undefined
}