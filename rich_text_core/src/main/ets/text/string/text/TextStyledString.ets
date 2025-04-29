// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { getTextDecorationStyle, getTextFontStyle } from "../../util/TextBISUUtils"

export function assembleText(
  text: string,
  baseString: MutableStyledString,
  fontSize: number,
  styles?: Map<string, string>
) {
  const textStyle = getTextFontStyle(fontSize, styles)

  const textString: MutableStyledString = new MutableStyledString(text, [{
    start: 0,
    length: text.length,
    styledKey: StyledStringKey.FONT,
    styledValue: textStyle
  }])

  const decorationStyle = getTextDecorationStyle(styles)
  if (decorationStyle.length > 0) {
    decorationStyle.forEach(styleItem => {
      textString.setStyle({
        start: 0,
        length: text.length,
        styledKey: StyledStringKey.DECORATION,
        styledValue: styleItem
      })
    })
  }

  baseString.appendStyledString(textString)
}