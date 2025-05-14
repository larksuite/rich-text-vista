import { Node } from 'commonmark'
import { StyledTextNode } from '../../../text/node/StyledTextNode'
import { TextBISUConstants } from '../../../text/util/TextBISUConstants'

/**
 * Parses a Markdown string and converts it into an Abstract Syntax Tree (AST) represented by a Node.
 *
 * @param {string} markdownString - The Markdown string to be parsed.
 * @returns {Node} - The resulting AST Node.
 *
 * The function handles the following Markdown elements:
 * - **bold**: Converts the content to a StyledTextNode with a bold font weight.
 * - *italic*: Converts the content to a StyledTextNode with italic font style.
 * - ~~strikethrough~~: Converts the content to a StyledTextNode with strikethrough text decoration.
 * - <u>underline</u>: Converts the content to a StyledTextNode with underline text decoration.
 */
export function parseMarkdownAsAST(markdownString: string): Node {
  const result: Node = new Node()
  const regex =
    /(\*\*(.*?)\*\*)|(\*(.*?)\*)|(<u>(.*?)<\/u>)|(~~(.*?)~~)|([^*<~]+)/gs
  let match: RegExpExecArray | null
  while ((match = regex.exec(markdownString)) !== null) {
    if (match[1]) {
      // **bold**
      const boldNode = new StyledTextNode(match[2] || "", undefined, undefined)
      const styleMap = new Map<string, string>()
      styleMap.set(TextBISUConstants.STYLE_FONT_WEIGHT, TextBISUConstants.FONT_WEIGHT_BOLD)
      boldNode.attributes = styleMap
      result.appendChild(boldNode)
    } else if (match[3]) {
      // *italic*
      const italicNode = new StyledTextNode(match[4] || "", undefined, undefined)
      const styleMap = new Map<string, string>()
      styleMap.set(TextBISUConstants.STYLE_FONT_STYLE, TextBISUConstants.ITALIC)
      italicNode.attributes = styleMap
      result.appendChild(italicNode)
    } else if (match[5]) {
      // <u>underline</u>
      const underlineNode = new StyledTextNode(match[6] || "", undefined, undefined)
      const styleMap = new Map<string, string>()
      styleMap.set(TextBISUConstants.STYLE_TEXT_DECORATION, TextBISUConstants.UNDERLINE)
      underlineNode.attributes = styleMap
      result.appendChild(underlineNode)
    } else if (match[7]) {
      // ~~strikethrough~~
      const strikethroughNode = new StyledTextNode(match[8] || "", undefined, undefined)
      const styleMap = new Map<string, string>()
      styleMap.set(TextBISUConstants.STYLE_TEXT_DECORATION, TextBISUConstants.STRIKE_THROUGH)
      strikethroughNode.attributes = styleMap
      result.appendChild(strikethroughNode)
    } else if (match[9]) {
      // Plain text
      const plainTextNode = new StyledTextNode(match[9], undefined, undefined)
      result.appendChild(plainTextNode)
    }
  }
  return result
}