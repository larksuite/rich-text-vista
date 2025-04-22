import { Node } from "@lark/commonmark";
import { NodeParseContext } from "./NodeParseContext";

export class DefaultNodeParseContext<T extends Node> implements NodeParseContext<T> {
  node: T;

  constructor(node: T) {
    this.node = node
  }
}