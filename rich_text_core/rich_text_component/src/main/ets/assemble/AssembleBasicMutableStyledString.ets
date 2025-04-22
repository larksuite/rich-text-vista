import { AnchorNode, AnchorStyledStringProducer } from '@im/rich_text_anchor'
import { MarkdownPlugin } from '@im/rich_text_base'
import { BasicTagNodeMapper } from '../tag/BasicTagNodeMapper'
import { TextStyledStringProducer, ImageStyledStringProducer, StyledTextNode } from '@im/rich_text_text'
import { ImageNode, Node } from '@lark/commonmark'
import { BasicRichTextElementTag } from '../tag/BasicRichTextElementTag'

/**
 * Assembles a mutable styled string based on the provided inline node and its corresponding tag.
 *
 * @param {Map<number, MarkdownPlugin>} pluginCache - A cache of markdown plugins mapped by their tag numbers.
 * @param {Node} node - The node to be processed and converted into a styled string.
 * @param {number} fontSize - The font size to be used for the styled string.
 * @param {number} componentId - The component ID used in the styled string.
 * @param {MutableStyledString} baseString - The base mutable styled string to which the new styled string will be appended.
 * @param {() => void} onAnchorClick - The callback function to be executed when an anchor is clicked.
 */
export async function assembleInlineElementsToMutableStyledString(
  baseString: MutableStyledString,
  pluginCache: Map<number, MarkdownPlugin>,
  node: Node,
  fontSize: number,
  componentId: number,
  onAnchorClick: () => void
) {
  switch (BasicTagNodeMapper.getTagFromNode(node)) {
    case BasicRichTextElementTag.TEXT:
      const textProducer = (pluginCache.get(BasicRichTextElementTag.TEXT)?.producer as TextStyledStringProducer)
      const textStyledString = textProducer.produceStyledString((node as StyledTextNode), fontSize)
      baseString.appendStyledString(textStyledString)
      break
    case BasicRichTextElementTag.IMG:
      const imageProducer = (pluginCache.get(BasicRichTextElementTag.IMG)?.producer as ImageStyledStringProducer)
      const imageStyledString = imageProducer.produceStyledString(node as ImageNode)
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