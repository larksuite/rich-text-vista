import {
  Node,
  AnchorNode,
  AnchorProperty,
  ListItemNode,
  OrderedListNode,
  RichTextComponent,
  StyledTextNode,
  UnorderedListNode,
  IExtensionRichText,
  ParagraphNode,
  RootNode,
} from 'rich_text_core';
import { RichTextRepresentation } from 'rich_text_core/src/main/ets/component/representation/RichTextRepresentation';
import { TextBISUConstants } from 'rich_text_core/src/main/ets/text/util/TextBISUConstants';
import { IOLProperty } from 'rich_text_core/src/main/ets/block/property/ol/IOLProperty';
import { OLPropertyType } from 'rich_text_core/src/main/ets/block/property/ol/OLPropertyType';
import { StyledImageNode } from 'rich_text_core/src/main/ets/image/node/StyledImageNode';
import { AtNode } from '../at_extension/node/AtNode';
import { AtExtensionRichText } from '../at_extension/AtExtensionRichText';

@Entry
@ComponentV2
struct Index {
  @Param normalContent: string = "This is plain text"
  @Param boldContent: string = "This is bold text"
  @Param italicContent: string = "This is italic text"
  @Param underlineContent: string = "This is text with underscore"
  @Param strikethroughContent: string = "This is text with strikethrough"
  @Param linkContent: string = "This is a link"
  @Param link: string = "https://developer.huawei.com/consumer/cn/"
  @Param extensionList: Array<IExtensionRichText<Node>> = []
  scroller: Scroller = new Scroller()

  build() {
    Scroll(this.scroller) {
      Column() {
        /**
         * Sample Usage 1: Normal Text
         */
        RichTextComponent({
          richText: this.generateNormalText(),
          fontSize: 16,
        })
          .margin({
            top: 10,
            bottom: 10
          })

        /**
         * Sample Usage 2: Bold Text
         */
        RichTextComponent({
          richText: this.generateBoldStyledText(),
          fontSize: 16,
        })

        /**
         * Sample Usage 3: Italic Text
         */
        RichTextComponent({
          richText: this.generateItalicStyledText(),
          fontSize: 16,
        })

        /**
         * Sample Usage 4: Underline Text
         */
        RichTextComponent({
          richText: this.generateUnderlineStyledText(),
          fontSize: 16,
        })

        /**
         * Sample Usage 5: Strikethrough Text
         */
        RichTextComponent({
          richText: this.generateStrikethroughStyledText(),
          fontSize: 16,
        })
          .margin({
            bottom: 10
          })

        /**
         * Sample Usage 6: Link Text
         */
        RichTextComponent({
          richText: this.generateLinkStyledText(),
          fontSize: 16,
        })
          .margin({
            bottom: 10
          })

        /**
         * Sample Usage 7: Paragraph Text
         */
        RichTextComponent({
          richText: this.generateParagraphStyledText(),
          fontSize: 16,
        })
          .margin({
            bottom: 10
          })

        /**
         * Sample Usage 8: OrderList Text
         */
        RichTextComponent({
          richText: this.generateOrderListStyledText(),
          fontSize: 16,
        })
          .margin({
            bottom: 10
          })

        /**
         * Sample Usage 9: UnOrderList Text
         */
        RichTextComponent({
          richText: this.generateUnOrderListStyledText(),
          fontSize: 16,
        })
          .margin({
            bottom: 10
          })

        /**
         * Sample Usage 10: Text And Image
         */
        RichTextComponent({
          richText: this.generateTextAndImage(),
          fontSize: 16,
        })
          .margin({
            bottom: 15
          })

        /**
         * Sample Usage 11: CustomSpan
         */
        RichTextComponent({
          richText: this.generateCustomSpan(),
          fontSize: 16,
          extensionList: this.extensionList
        })
          .margin({
            bottom: 10
          })
      }
      .height('100%')
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
  }

  private generateNormalText(): RichTextRepresentation {
    const rootNode = new RootNode()
    const richTextRepresentation = new RichTextRepresentation()
    const styledTextNode = new StyledTextNode(this.normalContent, undefined, undefined)
    rootNode.appendChild(styledTextNode)
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateBoldStyledText() {
    const rootNode = new RootNode()
    const styles: Map<string, string> = new Map()
    styles.set(TextBISUConstants.STYLE_FONT_WEIGHT, TextBISUConstants.FONT_WEIGHT_BOLD)
    const styledTextNode = new StyledTextNode(this.boldContent, undefined, undefined)
    styledTextNode.attributes = styles
    rootNode.appendChild(styledTextNode)
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateItalicStyledText() {
    const rootNode = new RootNode()
    const styles: Map<string, string> = new Map()
    styles.set(TextBISUConstants.STYLE_FONT_STYLE, TextBISUConstants.ITALIC)
    const styledTextNode = new StyledTextNode(this.italicContent, undefined, undefined)
    styledTextNode.attributes = styles
    rootNode.appendChild(styledTextNode)
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateUnderlineStyledText() {
    const rootNode = new RootNode()
    const styles: Map<string, string> = new Map()
    styles.set(TextBISUConstants.STYLE_TEXT_DECORATION, TextBISUConstants.UNDERLINE)
    const styledTextNode = new StyledTextNode(this.underlineContent, undefined, undefined)
    styledTextNode.attributes = styles
    rootNode.appendChild(styledTextNode)
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateStrikethroughStyledText() {
    const rootNode = new RootNode()
    const styles: Map<string, string> = new Map()
    styles.set(TextBISUConstants.STYLE_TEXT_DECORATION, TextBISUConstants.STRIKE_THROUGH)
    const styledTextNode = new StyledTextNode(this.strikethroughContent, undefined, undefined)
    styledTextNode.attributes = styles
    rootNode.appendChild(styledTextNode)
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateLinkStyledText() {
    const rootNode = new RootNode()
    const anchorProperty = new AnchorProperty(this.linkContent ?? "", this.link ?? "")
    const anchorNode = new AnchorNode(anchorProperty)
    rootNode.appendChild(anchorNode)
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateParagraphStyledText() {
    const rootNode = new RootNode()
    const firstParagraphTextNode = new StyledTextNode("This is the first paragraph", undefined, undefined)
    rootNode.appendChild(firstParagraphTextNode)
    const firstParagraph = new ParagraphNode()
    rootNode.appendChild(firstParagraph)

    const secondParagraphTextNode = new StyledTextNode("This is the second paragraph", undefined, undefined)
    rootNode.appendChild(secondParagraphTextNode)
    const secondParagraph = new ParagraphNode()
    rootNode.appendChild(secondParagraph)

    const thirdParagraphTextNode = new StyledTextNode("This is the third paragraph", undefined, undefined)
    rootNode.appendChild(thirdParagraphTextNode)
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateOrderListStyledText() {
    const rootNode = new RootNode()
    const property: IOLProperty = {
      type: OLPropertyType.NUMBER,
      start: 1
    }
    const firstOrderListNode = new OrderedListNode(property)
    rootNode.appendChild(firstOrderListNode)
    const firstListNode = new ListItemNode()
    firstOrderListNode.appendChild(firstListNode)
    const firstItemTextNode = new StyledTextNode("This is the first list item", undefined, undefined)
    firstListNode.appendChild(firstItemTextNode)

    const secondListNode = new ListItemNode()
    const secondItemTextNode = new StyledTextNode("This is the second list item", undefined, undefined)
    secondListNode.appendChild(secondItemTextNode)
    firstListNode.insertAfter(secondListNode)

    const thirdListNode = new ListItemNode()
    const thirdItemTextNode = new StyledTextNode("This is the third list item", undefined, undefined)
    thirdListNode.appendChild(thirdItemTextNode)
    secondListNode.insertAfter(thirdListNode)
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateUnOrderListStyledText() {
    const rootNode = new RootNode()
    const unOrderListNode = new UnorderedListNode()
    rootNode.appendChild(unOrderListNode)
    const firstListNode = new ListItemNode()
    unOrderListNode.appendChild(firstListNode)
    const firstItemTextNode = new StyledTextNode("This is the first unordered list item", undefined, undefined)
    firstListNode.appendChild(firstItemTextNode)

    const secondListNode = new ListItemNode()
    const secondItemTextNode = new StyledTextNode("This is the second unordered list item", undefined, undefined)
    secondListNode.appendChild(secondItemTextNode)
    firstListNode.insertAfter(secondListNode)

    const thirdListNode = new ListItemNode()
    const thirdItemTextNode = new StyledTextNode("This is the third unordered list item", undefined, undefined)
    thirdListNode.appendChild(thirdItemTextNode)
    secondListNode.insertAfter(thirdListNode)
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateTextAndImage() {
    const rootNode = new RootNode()
    const richTextRepresentation = new RichTextRepresentation()
    const firstTextNode = new StyledTextNode("These are images within text inline ", undefined, undefined)
    rootNode.appendChild(firstTextNode)
    const firstImageNode = new StyledImageNode()
    firstImageNode.resStr = $r("app.media.first_image")
    firstImageNode.width = 20
    firstImageNode.height = 20
    rootNode.appendChild(firstImageNode)

    const secondTextNode = new StyledTextNode(" and as a new block", undefined, undefined)
    rootNode.appendChild(secondTextNode)

    const paragraph = new ParagraphNode()
    rootNode.appendChild(paragraph)
    const secondImageNode = new StyledImageNode()
    secondImageNode.resStr = $r("app.media.second_image")
    secondImageNode.width = 150
    secondImageNode.height = 150
    rootNode.appendChild(secondImageNode)

    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private generateCustomSpan() {
    const rootNode = new RootNode()
    const richTextRepresentation = new RichTextRepresentation()
    const textNode = new StyledTextNode("These are custom spans: ", undefined, undefined)
    rootNode.appendChild(textNode)
    const firstAtNode = new AtNode()
    firstAtNode.name = "hello world"
    firstAtNode.hasBackground = true
    rootNode.appendChild(firstAtNode)

    const secondAtNode = new AtNode()
    secondAtNode.name = "hello world"
    secondAtNode.hasBackground = false
    rootNode.appendChild(secondAtNode)

    const atExtension = new AtExtensionRichText()
    this.extensionList.push(atExtension)

    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }
}