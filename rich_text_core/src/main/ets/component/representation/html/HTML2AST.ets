// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node, ParagraphNode } from 'commonmark'
import { AnchorNode } from '../../../anchor/node/AnchorNode'
import { AnchorProperty } from '../../../anchor/property/AnchorProperty'
import { ITextProperty } from '../../../text/property/ITextProperty'
import { StyledTextNode } from '../../../text/node/StyledTextNode'
import { TextBISUConstants } from '../../../text/util/TextBISUConstants'

/**
 * Parses an HTML string and converts it into an Abstract Syntax Tree (AST) represented by a Node.
 *
 * @param {string} htmlString - The HTML string to be parsed.
 * @returns {Node} - The resulting AST Node.
 *
 * The function handles the following HTML elements:
 * - <b>: Converts the content to a StyledTextNode with a bold font weight.
 * - <i>: Converts the content to a StyledTextNode with italic font style.
 * - <u>: Converts the content to a StyledTextNode with underline text decoration.
 * - <s>: Converts the content to a StyledTextNode with strikethrough text decoration.
 * - <p>: Converts the content to a ParagraphNode.
 * - <strong>: Converts the content to a StyledTextNode with a bold font weight.
 * - <a>: Converts the content to an AnchorNode with the href attribute.
 * - <span style="...">: Extracts the text color from the style attribute and applies it to a StyledTextNode.
 * - Plain text: Converts plain text content to a StyledTextNode.
 */
export function parseHTMLAsAST(htmlString: string): Node {
  // Remove <html> and <body> tags if present
  const cleanedHtmlString = htmlString.replace(/<\/?(html|body)[^>]*>/gi, '')
  const decodedHtmlString = cleanedHtmlString.replace(
    /\\u([\dA-F]{4})/gi,
    (match: string, grp: string) => String.fromCharCode(parseInt(grp, 16)),
  )
  const result: Node = new Node()
  const regex =
    /(<b>(.*?)<\/b>)|(<i>(.*?)<\/i>)|(<u>(.*?)<\/u>)|(<s>(.*?)<\/s>)|(<p>(.*?)<\/p>)|(<strong>(.*?)<\/strong>)|(<a\s[^>]*?href=['"]?([^'"]+)?['"]?[^>]*>(.*?)<\/a>)|(<span\s+style=['"](.*?)['"]?>(.*?)<\/span>)|([^<]+)/gs
  let match: RegExpExecArray | null
  while ((match = regex.exec(decodedHtmlString)) !== null) {
    if (match[1]) {
      // <b>...</b>
      const parsedBoldContent = parseHTMLAsAST(match[2] || "")
      if (parsedBoldContent) {
        const styleMap = new Map<string, string>()
        styleMap.set(TextBISUConstants.STYLE_FONT_WEIGHT, TextBISUConstants.FONT_WEIGHT_BOLD)
        if (parsedBoldContent.getFirstChild() instanceof StyledTextNode) {
          (parsedBoldContent.getFirstChild() as StyledTextNode).attributes = styleMap
        }
        result.appendChild(parsedBoldContent)
      }
    } else if (match[3]) {
      // <i>...</i>
      const parsedItalicContent = parseHTMLAsAST(match[4] || "")
      if (parsedItalicContent) {
        const styleMap = new Map<string, string>()
        styleMap.set(TextBISUConstants.STYLE_FONT_STYLE, TextBISUConstants.ITALIC)
        if (parsedItalicContent.getFirstChild() instanceof StyledTextNode) {
          (parsedItalicContent.getFirstChild() as StyledTextNode).attributes = styleMap
        }
        result.appendChild(parsedItalicContent)
      }
    } else if (match[5]) {
      // <u>...</u>
      const parsedUnderlineContent = parseHTMLAsAST(match[6] || "")
      if (parsedUnderlineContent) {
        const styleMap = new Map<string, string>()
        styleMap.set(TextBISUConstants.STYLE_TEXT_DECORATION, TextBISUConstants.UNDERLINE)
        if (parsedUnderlineContent.getFirstChild() instanceof StyledTextNode) {
          (parsedUnderlineContent.getFirstChild() as StyledTextNode).attributes = styleMap
        }
        result.appendChild(parsedUnderlineContent)
      }
    } else if (match[7]) {
      // <s>...</s>
      const parsedStrikethroughContent = parseHTMLAsAST(match[8] || "")
      if (parsedStrikethroughContent) {
        const styleMap = new Map<string, string>()
        styleMap.set(TextBISUConstants.STYLE_TEXT_DECORATION, TextBISUConstants.STRIKE_THROUGH)
        if (parsedStrikethroughContent.getFirstChild() instanceof StyledTextNode) {
          (parsedStrikethroughContent.getFirstChild() as StyledTextNode).attributes = styleMap
        }
        result.appendChild(parsedStrikethroughContent)
      }
    } else if (match[9]) {
      // <p>...</p>
      const parsedParagraphContent = parseHTMLAsAST(match[10] || "")
      if (parsedParagraphContent) {
        const paragraphNode = new ParagraphNode()
        paragraphNode.appendChild(parsedParagraphContent)
        result.appendChild(paragraphNode)
      }
    } else if (match[11]) {
      // <strong>...</strong>
      const parsedStrongContent = parseHTMLAsAST(match[12] || "")
      if (parsedStrongContent) {
        const styleMap = new Map<string, string>()
        styleMap.set(TextBISUConstants.STYLE_FONT_WEIGHT, TextBISUConstants.FONT_WEIGHT_BOLD)
        if (parsedStrongContent.getFirstChild() instanceof StyledTextNode) {
          (parsedStrongContent.getFirstChild() as StyledTextNode).attributes = styleMap
        }
        result.appendChild(parsedStrongContent)
      }
    } else if (match[13]) {
      // <a...>...</a>
      const href = match[14]
      const content = stripTags(match[15] || "")
      result.appendChild(new AnchorNode(new AnchorProperty(content, href)))
    } else if (match[16]) {
      // <span style="...">...</span>
      const textColor = extractTextColor(match[17] || "")
      const styleMap = new Map<string, string>()
      if (textColor) {
        styleMap.set('fontColor', textColor)
      }
      const textProperty: ITextProperty = {
        content: match[18] || ""
      }
      const styledTextNode =
        new StyledTextNode(textProperty.content, textProperty.i18nKey, textProperty.numberOfLines, match[18] || "")
      styledTextNode.attributes = styleMap
      result.appendChild(styledTextNode)
    } else if (match[19]) {
      // plain text
      if (match[19].trim() !== "") {
        const textProperty: ITextProperty = {
          content: match[19] || ""
        }
        const styledTextNode =
          new StyledTextNode(textProperty.content, textProperty.i18nKey, textProperty.numberOfLines, match[19] || "")
        result.appendChild(styledTextNode)
      }
    }
  }
  return result
}
function stripTags(html: string): string {
  return html.replace(/<\/?[^>]+(>|$)/g, "").trim()
}
function extractTextColor(style: string): string | undefined {
  const colorRegex = /color:\s*([^;]+)/
  const colorMatch = colorRegex.exec(style)
  if (colorMatch) {
    const colorValue = colorMatch[1]
    return colorValue.replace(/^@\{(.*)\}$/, '$1')
  }
  return undefined
}