import { Node } from '@lark/commonmark';

export interface IAnchorStyledStringProducer<T extends Node> {
  produceStyledString(
    parseContext: T,
    fontSize: number,
    fontColor: ResourceColor | undefined,
    uniqueId: number | undefined,
    openAnchor: () => void,
    onAnchorClick: () => void
  ): MutableStyledString
}