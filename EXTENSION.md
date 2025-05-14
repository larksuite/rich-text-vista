Custom Style Implementation Guide
=============

Implementing a custom style involves the following steps. We use an @ mention styled string as an example of how users can implement their custom styles:

**1. Define Custom Style Interface**

Create an interface extending the core `Extend` class to declare style-specific properties. This serves as the contract for your custom style's data structure.

*For @ mentions: Implement `AtNodeExtend` with necessary properties.*

```typescript
import { Extend } from 'rich_text_core'

export interface AtNodeExtend extends Extend {
  name: string
  hasBackground: boolean
}
```

**2. Create Style Node Class**

Extend the base `Node` class and implement your custom interface. This class will manage style state and property accessors.

*For @ mentions: Build `AtNode` with necessary getter/setter methods.*

```typescript
import { Node } from 'rich_text_core'

export class AtNode extends Node implements AtNodeExtend {
  private _name: string = ""
  private _hasBackground: boolean = true

  constructor() {
    super()
  }

  public get hasBackground(): boolean {
    return this._hasBackground
  }

  public set hasBackground(value: boolean) {
    this._hasBackground = value
  }

  public get name(): string {
    return this._name
  }

  public set name(name: string) {
    this._name = name
  }
}
```

**3. Declare Styled String Producer Interface**

Define an interface requiring `produceStyledString` method implementation. This decouples style rendering logic from core text processing.

*For @ mentions: Use `IAtNodeStyledStringProducer` with typed `parseContext` parameter.*

```typescript
import { Node } from 'rich_text_core';

export interface IAtNodeStyledStringProducer<T extends Node> {
  produceStyledString(parseContext: T): MutableStyledString;
}
```

**4. Implement Custom Span Renderer**

Subclass `CustomSpan` and override `onMeasure`/`onDraw` to handle layout and rendering. Include visual customization logic like background drawing.

*For @ mentions: Create an implementation `AtSpan`, inheriting from `CustomSpan`.*

```typescript
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
    // Font settings
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
```

**5. Build Style Assembly Function**

Create a factory method that constructs styled string segments by combining your `Node` and span implementations.

*For @ mentions: Implement `assembleAt` to wrap `AtNode` data in `AtSpan` instances.*

```typescript
import { AtNode } from "../node/AtNode"
import { AtSpan } from "../span/AtSpan"

export function assembleAt(
  at: AtNode,
  baseString: MutableStyledString
) {
  let atSpan: AtSpan = new AtSpan(at.name, at.hasBackground)
  let atStr: MutableStyledString = new MutableStyledString(atSpan)
  baseString.appendStyledString(atStr)
}
```

**6. Create Unified Style Producer**

Develop a producer class that implements both your style-specific interface and the core `BaseProducer`. This bridges custom styles with the rendering pipeline.

*For @ mentions: Use `AtStyledStringProducer` to coordinate `assembleAt` calls.*

```typescript
import { AtNode } from "../node/AtNode";
import { BaseProducer, RichTextExtendScope } from "rich_text_core";
import { assembleAt } from "../assemble/AtStyledString";
import { AtNodeExtend } from "../extend/AtNodeExtend";
import { IAtNodeStyledStringProducer } from "../produce/IAtNodeStyledStringProducer";

export class AtStyledStringProducer extends BaseProducer implements IAtNodeStyledStringProducer<AtNode>, RichTextExtendScope<AtNodeExtend> {
  produceStyledString(parseContext: AtNode): MutableStyledString {
    const atStyledString = new MutableStyledString("")
    assembleAt(parseContext, atStyledString)
    return atStyledString
  }
}
```

**7. Implement Extension Entry Point**

Subclass `IExtensionRichText` and override `produceMutableStyledString` to handle node type detection and producer delegation.

*For @ mentions: Create `AtExtensionRichText` that activates for `AtNode` instances.*

```typescript
import { IExtensionRichText, Node } from "rich_text_core";
import { AtNode } from "./node/AtNode";
import { AtStyledStringProducer } from "./produce/AtStyledStringProducer";

export class AtExtensionRichText implements IExtensionRichText<AtNode> {
  produceMutableStyledString(node: Node): MutableStyledString | undefined{
    if (node instanceof AtNode) {
      const producer = new AtStyledStringProducer()
      return producer.produceStyledString(node)
    } else {
      return undefined
    }
  }
}
```