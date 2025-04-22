import { BaseParseContext } from './BaseParseContext';
import { Node } from '@lark/commonmark';

export interface NodeParseContext<T extends Node> extends BaseParseContext {
  readonly node: T
}