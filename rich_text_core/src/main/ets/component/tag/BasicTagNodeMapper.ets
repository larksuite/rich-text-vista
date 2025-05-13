// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { ImageNode, Node, ParagraphNode, TextNode } from 'commonmark'
import { BasicRichTextElementTag } from './BasicRichTextElementTag'
import { AnchorNode } from '../../anchor/node/AnchorNode'
import { FigureNode } from '../../block/node/FigureNode'
import { DocsNode } from '../../block/node/DocsNode'
import { UnorderedListNode } from '../../block/node/UnorderedListNode'
import { OrderedListNode } from '../../block/node/OrderedListNode'
import { ListItemNode } from '../../block/node/ListItemNode'
import { QuoteNode } from '../../block/node/QuoteNode'

export class BasicTagNodeMapper {
  /**
   * Determines the tag type of a given AST node
   * @param {Node} node - The AST node to be analyzed
   * @returns {RichTextElementTag} - The corresponding RichTextElementTag
   */
  public static getTagFromNode(node: Node): BasicRichTextElementTag {
    if (node instanceof TextNode) {
      return BasicRichTextElementTag.TEXT
    } else if (node instanceof ImageNode) {
      return BasicRichTextElementTag.IMG
    } else if (node instanceof ParagraphNode) {
      return BasicRichTextElementTag.P
    } else if (node instanceof FigureNode) {
      return BasicRichTextElementTag.FIGURE
    } else if (node instanceof AnchorNode) {
      return BasicRichTextElementTag.A
    } else if (node instanceof DocsNode) {
      return BasicRichTextElementTag.DOCS
    } else if (node instanceof UnorderedListNode) {
      return BasicRichTextElementTag.UL
    } else if (node instanceof OrderedListNode) {
      return BasicRichTextElementTag.OL
    } else if (node instanceof ListItemNode) {
      return BasicRichTextElementTag.LI
    } else if (node instanceof QuoteNode) {
      return BasicRichTextElementTag.QUOTE
    } else {
      return BasicRichTextElementTag.CUSTOM
    }
  }
}