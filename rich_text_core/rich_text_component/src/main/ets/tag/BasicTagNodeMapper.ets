import { ImageNode, Node, ParagraphNode, TextNode } from '@lark/commonmark'
import { AnchorNode } from '@im/rich_text_anchor'
import { FigureNode, DocsNode, UnorderedListNode, OrderedListNode, ListItemNode, QuoteNode } from '@im/rich_text_block'
import { BasicRichTextElementTag } from './BasicRichTextElementTag'

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
      return BasicRichTextElementTag.UNKNOWN
    }
  }
}