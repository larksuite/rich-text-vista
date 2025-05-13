// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { IImageStyledStringProducer } from './IImageStyledStringProducer'
import { ImageNode } from 'commonmark'
import { assembleImage } from '../assemble/ImageStyledString'
import { ImageNodeExtend } from '../extend/ImageNodeExtend'
import { BaseProducer } from '../../base/plugin/ParsePlugin'
import { RichTextExtendScope } from '../../base/scope/RichTextExtendScope'
import { StyledImageNode } from '../node/StyledImageNode'

export class ImageStyledStringProducer extends BaseProducer implements IImageStyledStringProducer<ImageNode>, RichTextExtendScope<ImageNodeExtend> {
  produceStyledString(
    parseContext: StyledImageNode,
    width?: number | undefined,
    height?: number | undefined,
  ): MutableStyledString {
    const imageStyledString = new MutableStyledString("")
    assembleImage(parseContext, width, height, imageStyledString)
    return imageStyledString
  }
}