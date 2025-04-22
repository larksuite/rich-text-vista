import { Node } from '@lark/commonmark';

/**
 * Interface representing a handler for visiting nodes.
 *
 * @template T - The type of node that this handler will visit. It extends from the base Node class.
 */
export interface NodeVisitHandler<T extends Node> {
  /**
   * Method to be called when a node is visited.
   *
   * @param {T} node - The node that is being visited.
   */
  onVisitNode(node: T): void
}