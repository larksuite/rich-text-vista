import { IRichTextRepresentation } from '@im/rich_text_base'
import { Node, TextNode } from '@lark/commonmark'
import { parseHTMLAsAST } from './html/HTML2AST'

/**
 * Represents rich text content which can be either plain text or HTML.
 */
export class RichTextRepresentation implements IRichTextRepresentation {
  /**
   * Option: The plain text content.
   */
  plainText?: string

  /**
   * Option: The HTML content represented as a string.
   */
  htmlString?: string

  /**
   * Retrieves the rich text elements as a CommonMark AST (Abstract Syntax Tree).
   *
   * @returns {Node} The root node of the AST representing the rich text content.
   * If `plainText` is defined, returns a `TextNode` containing the plain text content.
   * If `htmlString` is defined, parses the HTML string into an AST and returns the root node.
   * If neither `plainText` nor `htmlString` are defined, returns an empty `Node`.
   */
  getElements(): Node {
    switch (true) {
      case !!this.plainText:
        return new TextNode(this.plainText ?? "")
      case !!this.htmlString:
        return parseHTMLAsAST(this.htmlString ?? "")
      default:
        return new Node()
    }
  }
}