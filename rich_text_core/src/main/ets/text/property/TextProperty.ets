// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { ITextProperty } from './ITextProperty';

export class TextProperty implements ITextProperty {
  private _content: string
  private _i18nKey: string | undefined
  private _numberOfLines: number | undefined

  constructor(content: string, i18nKey: string | undefined, numberOfLines: number | undefined) {
    this._content = content
    this._i18nKey = i18nKey
    this._numberOfLines = numberOfLines
  }

  get content() {
    return this._content
  }

  get i18nKey() {
    return this._i18nKey
  }

  get numberOfLines() {
    return this._numberOfLines
  }
}