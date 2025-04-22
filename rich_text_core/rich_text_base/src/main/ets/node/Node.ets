import { Extendable } from "@im/rich_text_base";
import { Node as CommonmarkNode } from "@lark/commonmark"

export abstract class Node extends CommonmarkNode implements Extendable {

}