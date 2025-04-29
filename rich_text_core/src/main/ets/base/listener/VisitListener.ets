// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

export interface VisitListener {
  start(): void

  end(): void
}