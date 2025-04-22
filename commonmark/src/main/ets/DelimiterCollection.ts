import {TextNode} from "./TextNode";

export interface Delimiter {
    cc: string,
    numdelims: number,
    origdelims: number,
    node: TextNode,
    previous: Delimiter|undefined,
    next: Delimiter|undefined,
    can_open: boolean,
    can_close: boolean
}

export interface PushArgs {
    cc: string,
    numdelims: number,
    origdelims: number,
    node: TextNode,
    can_open: boolean,
    can_close: boolean
}

export class DelimiterCollection {
    private top : Delimiter|undefined = undefined;  // used by handleDelim method
    public clear () {
        this.top = undefined;
    }
    public remove (delim : Delimiter|undefined) {
        if (!delim) {
            return;
        }
        if (delim.previous != undefined) {
            delim.previous.next = delim.next;
        }
        if (delim.next == undefined) {
            // top of stack
            this.top = delim.previous;
        } else {
            delim.next.previous = delim.previous;
        }
    };
    public peek () {
        return this.top;
    }
    public push (args : PushArgs) {
        this.top = {
            ...args,
            previous: this.top,
            next: undefined,
        };
        if (this.top.previous != undefined) {
            this.top.previous.next = this.top;
        }
        return this.top;
    }
}

export function removeDelimitersBetween(bottom : Delimiter|undefined, top : Delimiter) {
    if (bottom && bottom.next !== top) {
        bottom.next = top;
        top.previous = bottom;
    }
};
