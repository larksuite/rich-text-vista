import {TextNode} from "./TextNode";
import {BlockParser} from "./BlockParser";
import {InlineParser} from "./InlineParser";
import {RegexStream} from "./RegexStream";
import {Node} from "./Node";
import {Parser} from "./Parser";

export interface InlineContentParserArgs {
    inlineParsers : InlineParser[],
    textNodeCtor? : {new(str:string):TextNode},
}

// These are methods of an InlineContentParser object, defined below.
// An InlineContentParser keeps track of a subject (a string to be
// parsed) and a position in that subject.
//TODO consider having InlineContentParser CONTAIN RegexStream, rather than extending.
//     It makes more sense since the role of the parser isn't really to be a regex stream
export class InlineContentParser extends RegexStream {
    private inlineParsers : InlineParser[];
    private textNodeCtor : {new(str:string):TextNode};
    public constructor (args : InlineContentParserArgs) {
        super("");
        this.inlineParsers = args.inlineParsers;
        this.textNodeCtor = (args.textNodeCtor == undefined) ?
            TextNode :
            args.textNodeCtor;
    }

    public text (s : string) : TextNode {
        return new this.textNodeCtor(s);
    }
    public isTextNode (node : Node) : node is TextNode {
        return node instanceof TextNode;
    }

    // Parse the next inline element in subject, advancing subject position.
    // On success, add the result to block's children and return true.
    // On failure, return false.
    public parseInline (parser : Parser, blockParser : BlockParser, node : Node) {
        const c = this.peek();
        //console.log("peek", this.pos, c, String.fromCharCode(c));
        if (c == undefined) {
            return false;
        }
        for (let p of this.inlineParsers) {
            if (p.parse(this, node, blockParser, parser)) {
                //console.log("c", this.pos, c, fromCodePoint(c), this.inParsers.indexOf(p));
                return true;
            }
        }
        this.pos += 1;
        node.appendChild(this.text(c));
        //console.log("adding text", c, fromCodePoint(c));
        return true;
    };

    // Parse string content in block into inline children,
    public parse (parser : Parser, blockParser : BlockParser, node : Node) {
        for (let i of this.inlineParsers) {
            i.reinit();
        }
        this.subject = (blockParser.getString(node)).trim();
        this.pos = 0;
        while (this.parseInline(parser, blockParser, node)) {
        }
        for (let i of this.inlineParsers) {
            i.finalize();
        }
    }
    public reinitForDocument () {
        for (let i of this.inlineParsers) {
            i.reinitForDocument();
        }
    }
}
