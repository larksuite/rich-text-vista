import {Node} from "./../../../Node";
import {DelimiterCollection, Delimiter} from "./../../../DelimiterCollection";

export interface Bracket {
    node: Node,
    previous: Bracket|undefined,
    previousDelimiter: Delimiter|undefined,
    index: number,
    image: boolean,
    active: boolean,
    bracketAfter? : boolean
}
export class BracketCollection {
    private delimiters : DelimiterCollection;
    private top : Bracket|undefined = undefined;
    public constructor (delimiters : DelimiterCollection) {
        this.delimiters = delimiters;
    }
    public clear () {
        this.top = undefined;
    }

    public push (node : Node, index : number, image : boolean) {
        if (this.top != undefined) {
            this.top.bracketAfter = true;
        }
        this.top = {
            node: node,
            previous: this.top,
            previousDelimiter: this.delimiters.peek(),
            index: index,
            image: image,
            active: true
        };
    }
    public pop () {
        if (this.top == undefined) {
            throw new Error("Removed more than we added");
        }
        this.top = this.top.previous;
    }
    public peek () {
        return this.top;
    }
}
