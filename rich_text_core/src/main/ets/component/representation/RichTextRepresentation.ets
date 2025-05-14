// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT
import { Node } from 'commonmark'
import { parseHTMLAsAST } from './html/HTML2AST'
import { IRichTextRepresentation } from '../../base/representation/IRichTextRepresentation'
import { parseMarkdownAsAST } from './markdown/Markdown2AST'
import { StyledTextNode } from '../../../../../Index'

/**
 * Represents rich text content which can be either plain text, HTML, or an AST.
 */
export class RichTextRepresentation implements IRichTextRepresentation {
  /**
   * Option: The AST (Abstract Syntax Tree) representing the rich text content.
   */
  ast?: Node
  /**
   * Option: The plain text content.
   */
  plainText?: string
  /**
   * Option: The HTML content represented as a string.
   */
  htmlString?: string
  /**
   * Option: The Markdown content represented as a string.
   */
  markdownString?: string

  /**
   * Retrieves the rich text elements as a CommonMark AST (Abstract Syntax Tree).
   *
   * @returns {Node} The root node of the AST representing the rich text content.
   * If `plainText` is defined, returns a `TextNode` containing the plain text content.
   * If `ast` is defined, returns the `ast` node.
   * If `htmlString` is defined, parses the HTML string into an AST and returns the root node.
   * If none of `plainText`, `ast`, nor `htmlString` are defined, returns an empty `Node`.
   */
  getElements(): Node {
    switch (true) {
      case!!this.ast:
        return this.ast ?? new Node()
      case!!this.plainText:
        return new StyledTextNode(this.plainText ?? "", undefined, undefined)
      case!!this.htmlString:
        return parseHTMLAsAST(this.htmlString ?? "")
      case!!this.markdownString:
        return parseMarkdownAsAST(this.markdownString ?? "")
      default:
        return new Node()
    }
  }
}