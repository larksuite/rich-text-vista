import { BaseProducer, RichTextExtendScope } from '@im/rich_text_base';
import { IImageStyledStringProducer } from './IImageStyledStringProducer';
import { ImageNode } from '@lark/commonmark';
import { assembleImage } from '../../string/image/ImageStyledString';
import { ImageNodeExtend } from '../../extend/image/ImageNodeExtend';

export class ImageStyledStringProducer extends BaseProducer implements IImageStyledStringProducer<ImageNode>, RichTextExtendScope<ImageNodeExtend> {
  produceStyledString(
    parseContext: ImageNode,
    width?: number | undefined,
    height?: number | undefined,
  ): MutableStyledString {
    const imageStyledString = new MutableStyledString("")
    assembleImage(parseContext, width, height, imageStyledString)
    return imageStyledString
  }
}