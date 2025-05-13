// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node } from 'rich_text_core'
import { AtNodeExtend } from '../extend/AtNodeExtend'


export class AtNode extends Node implements AtNodeExtend {
  private _name: string = ""
  private _hasBackground: boolean = true

  constructor() {
    super()
  }

  public set hasBackground(value: boolean) {
    this._hasBackground = value
  }

  public get hasBackground(): boolean {
    return this._hasBackground
  }

  public get name(): string {
    return this._name
  }

  public set name(name: string) {
    this._name = name
  }
}