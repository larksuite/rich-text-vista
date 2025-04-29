// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from '@lark/commonmark'
import { AnchorNode } from '../../../anchor/node/AnchorNode'
import { AnchorProperty } from '../../../anchor/property/AnchorProperty'
import { ITextProperty } from '../../../text/property/ITextProperty'
import { StyledTextNode } from '../../../text/node/StyledTextNode'

/**
 * Parses an HTML string and converts it into an Abstract Syntax Tree (AST) represented by a Node.
 *
 * @param {string} htmlString - The HTML string to be parsed.
 * @returns {Node} - The resulting AST Node.
 *
 * The function handles the following HTML elements:
 * - <strong>: Converts the content to a StyledTextNode with a bold font weight.
 * - <a>: Converts the content to an AnchorNode with the href attribute.
 * - <span style="...">: Extracts the text color from the style attribute and applies it to a StyledTextNode.
 * - Plain text: Converts plain text content to a StyledTextNode.
 */
export function parseHTMLAsAST(htmlString: string): Node {
  const decodedHtmlString = htmlString.replace(
    /\\u([\dA-F]{4})/gi,
    (match: string, grp: string) => String.fromCharCode(parseInt(grp, 16)),
  )
  const result: Node = new Node();

  const regex =
    /(<strong>(.*?)<\/strong>)|(<a\s[^>]*?href=['"]?([^'"]+)?['"]?[^>]*>(.*?)<\/a>)|(<span\s+style=['"](.*?)['"]?>(.*?)<\/span>)|([^<]+)/gs;
  let match: RegExpExecArray | null;
  while ((match = regex.exec(decodedHtmlString)) !== null) {
    if (match[1]) {
      // <strong>...</strong>
      const parsedStrongContent = parseHTMLAsAST(match[2] || "");
      if (parsedStrongContent) {
        if ((parsedStrongContent.getFirstChild() as StyledTextNode).attributes) {
          const styleMap = new Map<string, string>();
          styleMap.set('fontWeight', 'bold');
          (parsedStrongContent.getFirstChild() as StyledTextNode).attributes = styleMap
        }
      }
      result.appendChild(parsedStrongContent)
    } else if (match[3]) {
      // <a...>...</a>
      const href = match[4]
      const content = stripTags(match[5] || "")
      result.appendChild(new AnchorNode(new AnchorProperty(content, href)))
    } else if (match[6]) {
      // <span style="...">...</span>
      const textColor = extractTextColor(match[7] || "");
      const styleMap = new Map<string, string>();
      if (textColor) {
        styleMap.set('fontColor', textColor);
      }
      const textProperty: ITextProperty = {
        content: match[8] || ""
      }
      const styledTextNode =
        new StyledTextNode(textProperty.content, textProperty.i18nKey, textProperty.numberOfLines, match[8] || "")
      styledTextNode.attributes = styleMap
      result.appendChild(new StyledTextNode(textProperty.content, textProperty.i18nKey, textProperty.numberOfLines,
        match[8] || ""))
    } else if (match[9]) {
      // plain text
      if (match[9].trim() !== "") {
        const textProperty: ITextProperty = {
          content: match[9] || ""
        }
        const styledTextNode =
          new StyledTextNode(textProperty.content, textProperty.i18nKey, textProperty.numberOfLines, match[9] || "")
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
  return undefined;
}