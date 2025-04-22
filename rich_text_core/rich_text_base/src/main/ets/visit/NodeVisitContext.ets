import { Node } from '@lark/commonmark';
import { NodeParseContext } from '../parse/NodeParseContext';

export interface NodeVisitContext<T extends Node> extends NodeParseContext<T> {}