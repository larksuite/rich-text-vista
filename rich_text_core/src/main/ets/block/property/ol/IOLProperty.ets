// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { OLPropertyType } from "./OLPropertyType"

export interface IOLProperty {
  type: OLPropertyType
  start: number
}