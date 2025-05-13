// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { taskpool } from '@kit.ArkTS'
import { image } from '@kit.ImageKit'
import { StyledImageNode } from '../node/StyledImageNode'

export async function assembleImage(
  parseContext: StyledImageNode,
  width: number | undefined,
  height: number | undefined,
  baseString: MutableStyledString,
) {

  const options: ResourceImageAttachmentOptions = {
    resourceValue: parseContext.resStr,
    objectFit: ImageFit.Contain,
    size: {
      width: parseContext.width,
      height: parseContext.height
    }
  }
  const imageString: MutableStyledString = new MutableStyledString(new ImageAttachment(options))

  baseString.appendStyledString(imageString)
}

export async function getPixelMapFromPath(path: string): Promise<PixelMap> {
  return await taskpool.execute(loadPixelMap, path) as PixelMap
}

@Concurrent
async function loadPixelMap(path: string): Promise<PixelMap> {
  const imageSource = image.createImageSource(path)
  const pixelMap = imageSource.createPixelMapSync()
  imageSource.release()
  pixelMap.setTransferDetached(true)
  return pixelMap
}