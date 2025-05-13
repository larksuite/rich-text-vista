// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { BasicTagNodeMapper } from '../tag/BasicTagNodeMapper'
import { Node } from 'commonmark'
import { BasicRichTextElementTag } from '../tag/BasicRichTextElementTag'
import { MarkdownPlugin } from '../../base/plugin/ParsePlugin'
import { AnchorNode } from '../../anchor/node/AnchorNode'
import { AnchorStyledStringProducer } from '../../anchor/produce/AnchorStyledStringProducer'
import { TextStyledStringProducer } from '../../text/produce/text/TextStyledStringProducer'
import { ImageStyledStringProducer } from '../../image/produce/ImageStyledStringProducer'
import { StyledTextNode } from '../../text/node/StyledTextNode'
import { StyledImageNode } from '../../image/node/StyledImageNode'
import { IExtensionRichText } from '../../extension/IExtensionRichText'

/**
 * Assembles a mutable styled string based on the provided inline node and its corresponding tag.
 *
 * @param {Map<number, MarkdownPlugin>} pluginCache - A cache of markdown plugins mapped by their tag numbers.
 * @param {Node} node - The node to be processed and converted into a styled string.
 * @param {number} fontSize - The font size to be used for the styled string.
 * @param {number} componentId - The component ID used in the styled string.
 * @param {MutableStyledString} baseString - The base mutable styled string to which the new styled string will be appended.
 * @param {() => void} onAnchorClick - The callback function to be executed when an anchor is clicked.
 * @param {Array<IExtensionRichText<Node>>} extensionList - The list of extensions corresponding to custom styles.
 */
export async function assembleInlineElementsToMutableStyledString(
  baseString: MutableStyledString,
  pluginCache: Map<number, MarkdownPlugin>,
  node: Node,
  fontSize: number,
  componentId: number,
  onAnchorClick: (linkUrl?:string) => void,
  extensionList?: Array<IExtensionRichText<Node>>,
) {
  if (BasicTagNodeMapper.getTagFromNode(node) === BasicRichTextElementTag.CUSTOM) {
    extensionList?.forEach(item => {
      const styledString = item.produceMutableStyledString(node)
      if (styledString) {
        baseString.appendStyledString(styledString)
      }
    })
  }

  switch (BasicTagNodeMapper.getTagFromNode(node)) {
    case BasicRichTextElementTag.TEXT:
      const textProducer = (pluginCache.get(BasicRichTextElementTag.TEXT)?.producer as TextStyledStringProducer)
      const textStyledString = textProducer.produceStyledString((node as StyledTextNode), fontSize)
      baseString.appendStyledString(textStyledString)
      break
    case BasicRichTextElementTag.IMG:
      const imageProducer = (pluginCache.get(BasicRichTextElementTag.IMG)?.producer as ImageStyledStringProducer)
      const imageStyledString = imageProducer.produceStyledString(node as StyledImageNode)
      baseString.appendStyledString(imageStyledString)
      break
    case BasicRichTextElementTag.A:
      const anchorStyledString = (pluginCache.get(BasicRichTextElementTag.A)?.producer as AnchorStyledStringProducer)
        .produceStyledString((node as AnchorNode), fontSize, Color.Blue, componentId, () => {
        }, onAnchorClick)
      baseString.appendStyledString(anchorStyledString)
      break
  }
}