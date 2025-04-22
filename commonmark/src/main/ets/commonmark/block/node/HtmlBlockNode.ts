import {Node} from "./../../../Node";

export class HtmlBlockNode extends Node {
    public htmlBlockType : number = -1;
    public stringContent : string = "";
    public literal : string = "";
}
