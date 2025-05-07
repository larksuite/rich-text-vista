// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from 'commonmark';

export interface IAnchorStyledStringProducer<T extends Node> {
  produceStyledString(
    parseContext: T,
    fontSize: number,
    fontColor: ResourceColor | undefined,
    uniqueId: number | undefined,
    openAnchor: () => void,
    onAnchorClick: () => void
  ): MutableStyledString
}