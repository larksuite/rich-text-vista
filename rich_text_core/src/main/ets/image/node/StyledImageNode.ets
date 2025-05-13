// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { ImageNode } from "commonmark"
import { ImageNodeExtend } from "../extend/ImageNodeExtend"

export class StyledImageNode extends ImageNode implements ImageNodeExtend{
  resStr?: ResourceStr
  width?: number
  height?: number
}