import { AnchorNodeVisitHandler, AnchorStyledStringProducer } from "@im/rich_text_anchor";
import { MarkdownPlugin, markdownPlugin } from "@im/rich_text_base";
import { BasicRichTextElementTag } from "../tag/BasicRichTextElementTag";
import { TextNodeVisitHandler, TextStyledStringProducer } from "@im/rich_text_text";

export class BasicCollectMarkdownPlugin {
  private pluginCache = new Map<number, MarkdownPlugin>();

  getPlugins(): Map<number, MarkdownPlugin> {
    this.pluginCache = collectMarkdownPlugin()
    return this.pluginCache
  }
}

function collectMarkdownPlugin(): Map<number, MarkdownPlugin> {

  const pluginMap: Map<number, MarkdownPlugin> = new Map()

  const anchor = markdownPlugin(
    (visit) => {
      visit.use(new AnchorNodeVisitHandler())
    },
    (producer) => {
      producer.use(new AnchorStyledStringProducer());
    }
  )
  pluginMap.set(BasicRichTextElementTag.A, anchor)

  const text = markdownPlugin(
    (visit) => {
      visit.use(new TextNodeVisitHandler())
    },
    (producer) => {
      producer.use(new TextStyledStringProducer());
    }
  )
  pluginMap.set(BasicRichTextElementTag.TEXT, text)


  return pluginMap
}