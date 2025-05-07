// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from "commonmark";
import { NodeParseContext } from "./NodeParseContext";

export class DefaultNodeParseContext<T extends Node> implements NodeParseContext<T> {
  node: T;

  constructor(node: T) {
    this.node = node
  }
}