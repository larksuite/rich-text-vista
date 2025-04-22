import { Node } from '@lark/commonmark'
import { ConfigurationConstant } from '@kit.AbilityKit'
import { assembleText } from '@im/rich_text_text'
import { ListNodeUtil, MarkdownPlugin } from '@im/rich_text_base'
import { assembleInlineElementsToMutableStyledString } from './assemble/AssembleBasicMutableStyledString'
import { BasicCollectMarkdownPlugin } from './plugin/BasicCollectMarkdownPlugin'
import { RichTextRepresentation } from './representation/RichTextRepresentation'
import { AnchorNode } from '@im/rich_text_anchor'
import { BasicRichTextElementTag } from './tag/BasicRichTextElementTag'
import { BasicTagNodeMapper } from './tag/BasicTagNodeMapper'
import { OrderedListNode } from '@im/rich_text_block'

const TAG = 'RichTextComponent'

/**
 * This class represents a rich text component that can parse nodes into a styled string.
 */
@ComponentV2
export struct RichTextComponent {
  @Param @Require richText: RichTextRepresentation
  @Param textAlign: TextAlign | undefined = undefined
  @Param fontSize: number = DEFAULT_TEXT_SIZE
  @Param fontColor: ResourceColor = Color.Black
  @Param lineHeight: number | undefined = undefined
  @Param maxLines: number | undefined = undefined
  @Param textOverflow: TextOverflow | undefined = undefined
  @Param ellipsisMode: EllipsisMode | undefined = undefined
  @Param selectionStart: number = -1
  @Param selectionEnd: number = -1
  @Local private _selectionStart: number = -1
  @Local private _selectionEnd: number = -1
  @Param updateSpan: string | Resource = ''
  @Param canCopyMessage: boolean = false
  @Once @Param selectCallback: (start: number, end: number) => void = () => {
  }
  @Param currentColorMode: number = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
  private selectedStartInternal = -1
  private selectedEndInternal = -1
  @Param fallbackString: string = ""

  node?: Node
  controller: TextController = new TextController()
  pluginCache = new Map<number, MarkdownPlugin>()
  @Once @Param onAnchorClick: (url?: string) => void = () => {
  }
  @Param isReused: boolean = false
  isFirstAttach = true

  aboutToAppear(): void {
    this._selectionStart = this.selectionStart
    this._selectionEnd = this.selectionEnd
    const basicCollectMarkdownPlugin = new BasicCollectMarkdownPlugin()
    this.pluginCache = basicCollectMarkdownPlugin.getPlugins()
  }

  @Monitor('selectionStart', 'selectionEnd')
  onSelectionStartEndChange() {
    this._selectionStart = this.selectionStart
    this._selectionEnd = this.selectionEnd
  }

  build() {
    Text(undefined, { controller: this.controller })
      .textAlign(this.textAlign)
      .fontSize(this.fontSize)
      .fontColor(this.fontColor)
      .lineHeight(this.lineHeight)
      .maxLines(this.maxLines)
      .textOverflow({ overflow: this.textOverflow })
      .ellipsisMode(this.ellipsisMode)
      .copyOption(this.canCopyMessage ? CopyOptions.InApp : CopyOptions.None)
      .selection(this._selectionStart, this._selectionEnd)
      .onAttach(() => {
        if (this.isFirstAttach) {
          this.onRichTextChange()
          this.isFirstAttach = false
        } else {
          if (!this.isReused) {
            this.onRichTextChange()
          }
        }
      })
      .onClick(() => {
        this.clearSelectStatus()
      })
      .onCopy(() => {
        // 选择了copy之后，去掉选中状态
        this.clearSelectStatus()
      })
      .onTextSelectionChange((selectionStart: number, selectionEnd: number) => {
        this.selectedStartInternal = selectionStart
        this.selectedEndInternal = selectionEnd
        if (this.selectCallback) {
          this.selectCallback(selectionStart, selectionEnd)
        }
      })
  }

  private showFallbackString() {
    const fallbackStyledString = new MutableStyledString(this.fallbackString)
    this.controller.setStyledString(fallbackStyledString)
  }

  @Monitor('richText')
  onRichTextChange() {
    const currentNode = this.richText.getElements()
    this.node = currentNode
    const newStyledString = new MutableStyledString("")

    this.parseNodeAsMutableStyledString(currentNode, newStyledString, this.getTagFromNode(currentNode))
      .then((styledString) => {
        if (this.node === currentNode) {
          if (styledString !== undefined && styledString.length > 0) {
            if (styledString.subStyledString(styledString.length - 1, 1).getString() === LINE_BREAK) {
              styledString.removeString(styledString.length - 1, 1)
            }
            this.controller.setStyledString(styledString)
          } else {
            this.showFallbackString()
          }
        }
      })
  }

  async parseNodeAsMutableStyledString(node: Node, baseString: MutableStyledString,
    parentTag: BasicRichTextElementTag | undefined = undefined,
    start: number = 0, nestLevel: number = 0, index: number = 0): Promise<MutableStyledString | undefined> {
    const tag = this.getTagFromNode(node)

    if (tag === BasicRichTextElementTag.LI) {
      const listNodeUtil = new ListNodeUtil();
      const prefix =
        parentTag === BasicRichTextElementTag.OL ? listNodeUtil.generateOrderedListSign(start + index, nestLevel) :
        listNodeUtil.generateUnorderedListSign(nestLevel)
      const indent = nestLevel > 1 ? "    ".repeat(nestLevel - 1) : " "
      const aNode = new AnchorNode({ content: indent + prefix })

      if (aNode) {
        await this.assembleStyledString(aNode, baseString)
      }
    }

    if (parentTag !== undefined) {
      await this.assembleStyledString(node, baseString)
    }

    let childNode = node.getFirstChild()
    let childIndex = 0
    while (childNode) {
      const newStart = tag === BasicRichTextElementTag.OL ? (node as OrderedListNode)?.ol?.start ?? 1 : 1
      const newNestLevel = tag === BasicRichTextElementTag.OL || tag === BasicRichTextElementTag.UL ? nestLevel + 1 : nestLevel

      await this.parseNodeAsMutableStyledString(childNode, baseString, this.getTagFromNode(node), newStart,
        newNestLevel, childIndex)

      childNode = childNode.getNext()
      childIndex++
    }

    if (CONTAINER_TAGS.includes(tag)) {
      assembleText(LINE_BREAK, baseString, this.fontSize)
    }
    return baseString
  }

  async assembleStyledString(node: Node, baseString: MutableStyledString) {
    await assembleInlineElementsToMutableStyledString(baseString, this.pluginCache, node, this.fontSize, this.getUniqueId(), this.onAnchorClick)
  }

  getTagFromNode(node: Node): BasicRichTextElementTag {
    return BasicTagNodeMapper.getTagFromNode(node)
  }

  private clearSelectStatus() {
    this._selectionStart = this.selectedStartInternal
    this._selectionEnd = this.selectedEndInternal
    this._selectionStart = -1
    this._selectionEnd = -1

    if (this.selectCallback) {
      this.selectCallback(-1, -1)
    }
  }
}

const LINE_BREAK = "\n"
const DEFAULT_TEXT_SIZE = 16
const CONTAINER_TAGS: BasicRichTextElementTag[] = [
  BasicRichTextElementTag.P,
  BasicRichTextElementTag.FIGURE,
  BasicRichTextElementTag.QUOTE,
  BasicRichTextElementTag.LI,
]