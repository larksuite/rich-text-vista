import { RichTextComponent } from 'rich_text_core';
import {
  RichTextRepresentation
} from 'rich_text_core/rich_text_component/src/main/ets/representation/RichTextRepresentation';

@Entry
@ComponentV2
struct Index {
  @Param content: string = "Hello world"

  build() {
    RelativeContainer() {
      RichTextComponent({
        richText: this.generateRichTextRepresentation(),
        fontSize: 16,
        fontColor: Color.Blue,
      })
    }
    .height('100%')
    .width('100%')
  }

  private generateRichTextRepresentation(): RichTextRepresentation {
    const richTextRepresentation = new RichTextRepresentation()
    richTextRepresentation.plainText = this.content
    return richTextRepresentation
  }
}