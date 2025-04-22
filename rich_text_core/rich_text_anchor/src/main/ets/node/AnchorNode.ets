import { IAnchorProperty } from '../property/IAnchorProperty';
import { Node, Range } from '@lark/commonmark';

export class AnchorNode extends Node {
  public anchor: IAnchorProperty

  public constructor(anchor: IAnchorProperty, sourceRange?: Range) {
    super(sourceRange)
    this.anchor = anchor
  }
}