// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { taskpool } from '@kit.ArkTS'
import { image } from '@kit.ImageKit'
import { ImageNode } from 'commonmark'

export async function assembleImage(
  parseContext: ImageNode,
  width: number | undefined,
  height: number | undefined,
  baseString: MutableStyledString,
) {
  const pixelMap = await getPixelMapFromPath(parseContext.destination)

  const imageString: MutableStyledString = new MutableStyledString(new ImageAttachment({
    value: pixelMap,
    size: (width && height) ? { width: width, height: height } : undefined,
    objectFit: ImageFit.Contain,
  }))

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