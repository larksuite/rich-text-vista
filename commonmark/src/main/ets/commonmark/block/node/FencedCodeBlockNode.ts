import {Node} from "./../../../Node";

export class FencedCodeBlockNode extends Node {
    public fenceLength : number = -1;
    public fenceChar   : string = "";
    public fenceOffset : number = -1;
    public info : string = "";
    public stringContent : string = "";
    public literal : string = "";
}
