// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Range, TextNode } from "commonmark"
import { ITextProperty } from "../property/ITextProperty"
import { TextProperty } from "../property/TextProperty"

/**
 * Represents a styled text node designed to support BISU upon plain text.
 * BISU (Bold, Italic, Stroke, Underscore) information is stored in the `attributes` map.
 */
export class StyledTextNode extends TextNode {
  /**
   * The text property associated with this node.
   */
  public text: ITextProperty

  /**
   * A map of attributes associated with this node, where BISU (Bold, Italic, Stroke, Underscore) information is stored.
   */
  public attributes: Map<string, string> = new Map()

  public constructor(content: string, i18nKey?: string, numberOfLines?: number,
    sourceRange?: string | Range) {
    super(sourceRange)
    this.text = new TextProperty(content, i18nKey, numberOfLines)
  }
}