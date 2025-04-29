// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { LengthMetrics } from '@kit.ArkUI'
import { IAnchorProperty } from '../property/IAnchorProperty'

export function assembleAnchor(
  anchor: IAnchorProperty,
  baseString: MutableStyledString,
  fontSize: number,
  fontColor: ResourceColor | undefined,
  uniqueId: number | undefined,
  openAnchor?: () => void,
  onAnchorClick?: () => void,
) {
  const anchorString: MutableStyledString = new MutableStyledString(anchor.content,
    [{
      start: 0,
      length: anchor.content.length,
      styledKey: StyledStringKey.FONT,
      styledValue: new TextStyle({
        fontSize: LengthMetrics.vp(fontSize),
        fontColor: fontColor ?? Color.Blue,
      })
    },
      {
        start: 0,
        length: anchor.content.length,
        styledKey: StyledStringKey.GESTURE,
        styledValue: new GestureStyle({
          onClick: () => {
            if (uniqueId) {
              openAnchor?.()
              onAnchorClick?.()
            }
          }
        })
      }
    ])
  baseString.appendStyledString(anchorString)
}