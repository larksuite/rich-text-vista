import {
  AnchorNode,
  AnchorProperty,
  IExtensionRichText,
  IOLProperty,
  ListItemNode,
  Node,
  OLPropertyType,
  OrderedListNode,
  ParagraphNode,
  RichTextComponent,
  RichTextRepresentation,
  RootNode,
  StyledImageNode,
  StyledTextNode,
  TextBISUConstants,
  UnorderedListNode
} from 'rich_text_core'
import { AtExtensionRichText } from '../at_extension/AtExtensionRichText'
import { AtNode } from '../at_extension/node/AtNode'

@Entry
@ComponentV2
struct Index {
  @Param titleContent: string = "RichTextVista Demo"
  @Param normalContent: string = "This is plain text"
  @Param boldContent: string = "This is bold text"
  @Param italicContent: string = "This is italic text"
  @Param underlineContent: string = "This is text with underscore"
  @Param strikethroughContent: string = "This is text with strikethrough"
  @Param linkContent: string = "This is a link"
  @Param link: string = "https://developer.huawei.com/consumer/cn/"
  @Param pureText: string = "This is plain text for pure string input"
  @Param htmlString: string = `
    <html>
      <body>
        <p><b>This is bold text for HTML input</b></p>
        <p><i>This is italic text for HTML input</i></p>
        <p><u>This is underlined text for HTML input</u></p>
        <p><s>This is strikethrough text for HTML input</s></p>
      </body>
    </html>`
  @Param markdownString: string = `
**This is bold text for Markdown input**
*This is italic text for Markdown input*
<u>This is underlined text for Markdown input</u>
~~This is strikethrough text for Markdown input~~
`
  @Param extensionList: Array<IExtensionRichText<Node>> = []
  scroller: Scroller = new Scroller()

  build() {
    Scroll(this.scroller) {
      Column() {
        RichTextComponent({
          richText: this.createBoldText(this.titleContent),
          fontSize: 24,
        })
          .margin({ top: 10, bottom: 10 })
        /**
         * Example 1: Normal Text
         */
        RichTextComponent({
          richText: this.createNormalText(this.normalContent),
          fontSize: 16,
        })
          .margin({ top: 10, bottom: 10 })

        /**
         * Example 2: Bold Text
         */
        RichTextComponent({
          richText: this.createBoldText(this.boldContent),
          fontSize: 16,
        })

        /**
         * Example 3: Italic Text
         */
        RichTextComponent({
          richText: this.createItalicText(this.italicContent),
          fontSize: 16,
        })

        /**
         * Example 4: Underlined Text
         */
        RichTextComponent({
          richText: this.createUnderlinedText(this.underlineContent),
          fontSize: 16,
        })

        /**
         * Example 5: Strikethrough Text
         */
        RichTextComponent({
          richText: this.createStrikethroughText(this.strikethroughContent),
          fontSize: 16,
        })
          .margin({ bottom: 10 })

        /**
         * Example 6: Link Text
         */
        RichTextComponent({
          richText: this.createLinkText(this.linkContent, this.link),
          fontSize: 16,
        })
          .margin({ bottom: 10 })

        /**
         * Example 7: Paragraph Text
         */
        RichTextComponent({
          richText: this.createParagraphText(),
          fontSize: 16,
        })
          .margin({ bottom: 10 })

        /**
         * Example 8: Ordered List Text
         */
        RichTextComponent({
          richText: this.createOrderedListText(),
          fontSize: 16,
        })
          .margin({ bottom: 10 })

        /**
         * Example 9: Unordered List Text
         */
        RichTextComponent({
          richText: this.createUnorderedListText(),
          fontSize: 16,
        })
          .margin({ bottom: 10 })

        /**
         * Example 10: Text and Image
         */
        RichTextComponent({
          richText: this.createTextAndImage(),
          fontSize: 16,
        })
          .margin({ bottom: 16 })

        /**
         * Example 11: Custom Span
         */
        RichTextComponent({
          richText: this.createCustomSpan(),
          fontSize: 16,
          extensionList: this.extensionList
        })
          .margin({ bottom: 10 })

        /**
         * Example 12: Pure Text Input format
         */
        RichTextComponent({
          richText: this.parsePureTextToAST(this.pureText),
          fontSize: 16
        })
          .margin({ bottom: 10 })

        /**
         * Example 13: HTML String Input Format
         */
        RichTextComponent({
          richText: this.parseHtmlStringToAST(this.htmlString),
          fontSize: 16
        })
          .margin({ bottom: 10 })

        /**
         * Example 14: Markdown String Input Format
         */
        RichTextComponent({
          richText: this.parseMarkdownStringToAST(this.markdownString),
          fontSize: 16
        })
          .margin({ bottom: 10 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 16, right: 16 })
      .width('auto')
      .expandSafeArea()
    }
    .scrollable(ScrollDirection.Vertical)
    .edgeEffect(EdgeEffect.Spring)
  }

  private createNormalText(content: string): RichTextRepresentation {
    const rootNode = new RootNode()
    const styledTextNode = new StyledTextNode(content)
    rootNode.appendChild(styledTextNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createBoldText(content: string): RichTextRepresentation {
    const rootNode = new RootNode()
    const styles: Map<string, string> = new Map()
    styles.set(TextBISUConstants.STYLE_FONT_WEIGHT, TextBISUConstants.FONT_WEIGHT_BOLD)
    const styledTextNode = new StyledTextNode(content)
    styledTextNode.attributes = styles
    rootNode.appendChild(styledTextNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createItalicText(content: string): RichTextRepresentation {
    const rootNode = new RootNode()
    const styles: Map<string, string> = new Map()
    styles.set(TextBISUConstants.STYLE_FONT_STYLE, TextBISUConstants.ITALIC)
    const styledTextNode = new StyledTextNode(content)
    styledTextNode.attributes = styles
    rootNode.appendChild(styledTextNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createUnderlinedText(content: string): RichTextRepresentation {
    const rootNode = new RootNode()
    const styles: Map<string, string> = new Map()
    styles.set(TextBISUConstants.STYLE_TEXT_DECORATION, TextBISUConstants.UNDERLINE)
    const styledTextNode = new StyledTextNode(content)
    styledTextNode.attributes = styles
    rootNode.appendChild(styledTextNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createStrikethroughText(content: string): RichTextRepresentation {
    const rootNode = new RootNode()
    const styles: Map<string, string> = new Map()
    styles.set(TextBISUConstants.STYLE_TEXT_DECORATION, TextBISUConstants.STRIKE_THROUGH)
    const styledTextNode = new StyledTextNode(content)
    styledTextNode.attributes = styles
    rootNode.appendChild(styledTextNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createLinkText(content: string, link: string): RichTextRepresentation {
    const rootNode = new RootNode()
    const anchorProperty = new AnchorProperty(content ?? "", link ?? "")
    const anchorNode = new AnchorNode(anchorProperty)
    rootNode.appendChild(anchorNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createParagraphText(): RichTextRepresentation {
    const rootNode = new RootNode()
    const firstParagraphTextNode = new StyledTextNode("This is the first paragraph")
    rootNode.appendChild(firstParagraphTextNode)
    const firstParagraph = new ParagraphNode()
    rootNode.appendChild(firstParagraph)

    const secondParagraphTextNode = new StyledTextNode("This is the second paragraph")
    rootNode.appendChild(secondParagraphTextNode)
    const secondParagraph = new ParagraphNode()
    rootNode.appendChild(secondParagraph)

    const thirdParagraphTextNode = new StyledTextNode("This is the third paragraph")
    rootNode.appendChild(thirdParagraphTextNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createOrderedListText(): RichTextRepresentation {
    const rootNode = new RootNode()
    const property: IOLProperty = {
      type: OLPropertyType.NUMBER,
      start: 1
    }
    const firstOrderListNode = new OrderedListNode(property)
    rootNode.appendChild(firstOrderListNode)
    const firstListNode = new ListItemNode()
    firstOrderListNode.appendChild(firstListNode)
    const firstItemTextNode = new StyledTextNode("This is the first ordered list item")
    firstListNode.appendChild(firstItemTextNode)

    const secondListNode = new ListItemNode()
    const secondItemTextNode = new StyledTextNode("This is the second ordered list item")
    secondListNode.appendChild(secondItemTextNode)
    firstListNode.insertAfter(secondListNode)

    const thirdListNode = new ListItemNode()
    const thirdItemTextNode = new StyledTextNode("This is the third ordered list item")
    thirdListNode.appendChild(thirdItemTextNode)
    secondListNode.insertAfter(thirdListNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createUnorderedListText(): RichTextRepresentation {
    const rootNode = new RootNode()
    const unorderedListNode = new UnorderedListNode()
    const listItemNode1 = new ListItemNode()
    const listItemNode2 = new ListItemNode()
    const listItemNode3 = new ListItemNode()

    const listItemTextNode1 = new StyledTextNode("This is the first unordered list item")
    const listItemTextNode2 = new StyledTextNode("This is the second unordered list item")
    const listItemTextNode3 = new StyledTextNode("This is the third unordered list item")

    listItemNode1.appendChild(listItemTextNode1)
    listItemNode2.appendChild(listItemTextNode2)
    listItemNode3.appendChild(listItemTextNode3)

    unorderedListNode.appendChild(listItemNode1)
    unorderedListNode.appendChild(listItemNode2)
    unorderedListNode.appendChild(listItemNode3)

    rootNode.appendChild(unorderedListNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createTextAndImage(): RichTextRepresentation {
    const rootNode = new RootNode()
    const firstTextNode = new StyledTextNode("These are images within text inline ")
    rootNode.appendChild(firstTextNode)
    const firstImageNode = new StyledImageNode()
    firstImageNode.resStr = $r("app.media.first_image")
    firstImageNode.width = 20
    firstImageNode.height = 20
    rootNode.appendChild(firstImageNode)

    const secondTextNode = new StyledTextNode(" and as a new block")
    rootNode.appendChild(secondTextNode)

    const paragraph = new ParagraphNode()
    rootNode.appendChild(paragraph)
    const secondImageNode = new StyledImageNode()
    secondImageNode.resStr = $r("app.media.second_image")
    secondImageNode.width = 80
    secondImageNode.height = 80
    rootNode.appendChild(secondImageNode)

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private createCustomSpan(): RichTextRepresentation {
    const rootNode = new RootNode()

    const textNode = new StyledTextNode("These are custom spans: ")
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

    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.ast = rootNode
    return richTextRepresentation
  }

  private parsePureTextToAST(content: string): RichTextRepresentation {
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.plainText = content
    return richTextRepresentation
  }

  private parseHtmlStringToAST(htmlContent: string): RichTextRepresentation {
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.htmlString = htmlContent
    return richTextRepresentation
  }

  private parseMarkdownStringToAST(markdownContent: string): RichTextRepresentation {
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.markdownString = markdownContent
    return richTextRepresentation
  }
}