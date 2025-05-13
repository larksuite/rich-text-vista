// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Extend } from 'rich_text_core'

export interface AtNodeExtend extends Extend {
  name: string
  hasBackground: boolean
}