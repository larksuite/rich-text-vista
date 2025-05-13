// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { common2D, drawing } from '@kit.ArkGraphics2D';
import measure from '@ohos.measure'

export class AtSpan extends CustomSpan {
  private textArea?: SizeOptions = undefined
  private width: number = 0
  private height: number = 0
  private word: string = ""
  hasBackground?: boolean = false
  content: string = ""

  constructor(content: string, hasBackground?: boolean) {
    super();
    this.content = content
    this.word = '@'.concat(content)
    this.textArea = getTextSize(this.word, '16vp')
    this.width = px2vp(Number(this.textArea.width))
    this.height = px2vp(Number(this.textArea.height))
    this.hasBackground = hasBackground
  }

  onMeasure(measureInfo: CustomSpanMeasureInfo): CustomSpanMetrics {
    return { width: this.width + px2vp(Number(25)), height: this.height + px2vp(Number(5)) }
  }

  onDraw(context: DrawContext, options: CustomSpanDrawInfo) {
    let canvas = context.canvas
    const brush = new drawing.Brush()

    this.drawBackground(canvas, brush, options)
    // 字体设置
    const font = new drawing.Font()
    font.setSize(vp2px(16))
    const textBlob = drawing.TextBlob.makeFromString(this.word, font, drawing.TextEncoding.TEXT_ENCODING_UTF8)
    canvas.attachBrush(brush)

    brush.setColor(this.getTextBrushColor())
    canvas.attachBrush(brush)
    let startX = options.x + 5
    canvas.drawTextBlob(textBlob, startX,
      options.lineBottom - (vp2px(this.height + 4) - Number(getTextSize(this.word, '16vp').height)))
    canvas.detachBrush()
  }

  getTextBrushColor(): common2D.Color {
    if (this.hasBackground) {
      return {
        alpha: 255,
        red: 255,
        green: 255,
        blue: 255
      }
    } else {
      return {
        alpha: 255,
        red: 4,
        green: 66,
        blue: 210
      }
    }
  }

  drawBackground(canvas: drawing.Canvas, brush: drawing.Brush, options: CustomSpanDrawInfo) {
    if (this.hasBackground) {
      brush.setColor({
        alpha: 255,
        red: 23,
        green: 88,
        blue: 240
      });
      canvas.attachBrush(brush)
      let rect: common2D.Rect = {
        left: options.x,
        top: options.lineTop,
        right: options.x + Number(this.textArea?.width) + 20,
        bottom: options.lineBottom
      }
      let roundRect = new drawing.RoundRect(rect, vp2px(8), vp2px(8));
      canvas.drawRoundRect(roundRect)
      canvas.detachBrush()
    }
  }
}

export function getTextSize(content: string, fontSize: string): SizeOptions {
  const size = measure.measureTextSize({
    textContent: content,
    fontSize,
  })
  return size
}