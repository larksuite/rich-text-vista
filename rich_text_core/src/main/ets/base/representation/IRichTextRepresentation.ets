// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from '@lark/commonmark'

/**
 * Interface representing a rich text content.
 */
export interface IRichTextRepresentation {
  /**
   * Retrieves the rich text elements as a CommonMark AST (Abstract Syntax Tree).
   *
   * @returns {Node} The root node of the AST representing the rich text content.
   */
  getElements(): Node
}