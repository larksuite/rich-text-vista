import { IAnchorProperty } from './IAnchorProperty';

export class AnchorProperty implements IAnchorProperty {
  private _content: string
  private _href: string

  constructor(content: string, href: string) {
    this._content = content
    this._href = href
  }

  get content(): string {
    return this._content
  }

  get href(): string {
    return this._href
  }
}