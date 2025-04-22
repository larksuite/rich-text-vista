import { Node } from '@lark/commonmark';

export interface IImageStyledStringProducer<T extends Node> {
  produceStyledString(
    parseContext: T,
    width: number | undefined,
    height: number | undefined,
  ): MutableStyledString
}