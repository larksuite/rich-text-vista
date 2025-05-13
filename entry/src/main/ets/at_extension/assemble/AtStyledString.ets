// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { AtNode } from "../node/AtNode"
import { AtSpan } from "../span/AtSpan"

export function assembleAt(
  at: AtNode,
  baseString: MutableStyledString
) {
  const atSpan: AtSpan = new AtSpan(at.name, at.hasBackground)
  const atStr: MutableStyledString = new MutableStyledString(atSpan)
  baseString.appendStyledString(atStr)
}