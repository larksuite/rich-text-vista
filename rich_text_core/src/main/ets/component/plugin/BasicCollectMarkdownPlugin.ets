// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { BasicRichTextElementTag } from "../tag/BasicRichTextElementTag"
import { AnchorNodeVisitHandler } from "../../anchor/visit/AnchorNodeVisitHandler"
import { AnchorStyledStringProducer } from "../../anchor/produce/AnchorStyledStringProducer"
import { MarkdownPlugin, markdownPlugin } from '../../base/plugin/ParsePlugin'
import { TextNodeVisitHandler } from "../../text/visit/TextNodeVisitHandler"
import { TextStyledStringProducer } from "../../text/produce/text/TextStyledStringProducer"


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