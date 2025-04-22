import {InlineParser} from "./InlineParser";
import {InlineContentParser} from "./InlineContentParser";
import {Node} from "./Node";
import {Delimiter, DelimiterCollection} from "./DelimiterCollection";
import {DelimitedInlineSubParser, ParseArgs} from "./DelimitedInlineSubParser";

const rePunctuation = new RegExp(/[!"#$%&'()*+,\-./:;<=>?@\[\]^_`{|}~\xA1\xA7\xAB\xB6\xB7\xBB\xBF\u037E\u0387\u055A-\u055F\u0589\u058A\u05BE\u05C0\u05C3\u05C6\u05F3\u05F4\u0609\u060A\u060C\u060D\u061B\u061E\u061F\u066A-\u066D\u06D4\u0700-\u070D\u07F7-\u07F9\u0830-\u083E\u085E\u0964\u0965\u0970\u0AF0\u0DF4\u0E4F\u0E5A\u0E5B\u0F04-\u0F12\u0F14\u0F3A-\u0F3D\u0F85\u0FD0-\u0FD4\u0FD9\u0FDA\u104A-\u104F\u10FB\u1360-\u1368\u1400\u166D\u166E\u169B\u169C\u16EB-\u16ED\u1735\u1736\u17D4-\u17D6\u17D8-\u17DA\u1800-\u180A\u1944\u1945\u1A1E\u1A1F\u1AA0-\u1AA6\u1AA8-\u1AAD\u1B5A-\u1B60\u1BFC-\u1BFF\u1C3B-\u1C3F\u1C7E\u1C7F\u1CC0-\u1CC7\u1CD3\u2010-\u2027\u2030-\u2043\u2045-\u2051\u2053-\u205E\u207D\u207E\u208D\u208E\u2308-\u230B\u2329\u232A\u2768-\u2775\u27C5\u27C6\u27E6-\u27EF\u2983-\u2998\u29D8-\u29DB\u29FC\u29FD\u2CF9-\u2CFC\u2CFE\u2CFF\u2D70\u2E00-\u2E2E\u2E30-\u2E42\u3001-\u3003\u3008-\u3011\u3014-\u301F\u3030\u303D\u30A0\u30FB\uA4FE\uA4FF\uA60D-\uA60F\uA673\uA67E\uA6F2-\uA6F7\uA874-\uA877\uA8CE\uA8CF\uA8F8-\uA8FA\uA8FC\uA92E\uA92F\uA95F\uA9C1-\uA9CD\uA9DE\uA9DF\uAA5C-\uAA5F\uAADE\uAADF\uAAF0\uAAF1\uABEB\uFD3E\uFD3F\uFE10-\uFE19\uFE30-\uFE52\uFE54-\uFE61\uFE63\uFE68\uFE6A\uFE6B\uFF01-\uFF03\uFF05-\uFF0A\uFF0C-\uFF0F\uFF1A\uFF1B\uFF1F\uFF20\uFF3B-\uFF3D\uFF3F\uFF5B\uFF5D\uFF5F-\uFF65]|\uD800[\uDD00-\uDD02\uDF9F\uDFD0]|\uD801\uDD6F|\uD802[\uDC57\uDD1F\uDD3F\uDE50-\uDE58\uDE7F\uDEF0-\uDEF6\uDF39-\uDF3F\uDF99-\uDF9C]|\uD804[\uDC47-\uDC4D\uDCBB\uDCBC\uDCBE-\uDCC1\uDD40-\uDD43\uDD74\uDD75\uDDC5-\uDDC9\uDDCD\uDDDB\uDDDD-\uDDDF\uDE38-\uDE3D\uDEA9]|\uD805[\uDCC6\uDDC1-\uDDD7\uDE41-\uDE43\uDF3C-\uDF3E]|\uD809[\uDC70-\uDC74]|\uD81A[\uDE6E\uDE6F\uDEF5\uDF37-\uDF3B\uDF44]|\uD82F\uDC9F|\uD836[\uDE87-\uDE8B]/);

const reUnicodeWhitespaceChar = /^\s/;

export class DelimitedInlineParser extends InlineParser {
    private delimiters : DelimiterCollection;
    private parsers    : DelimitedInlineSubParser[];
    public constructor (delimiters : DelimiterCollection, parsers : DelimitedInlineSubParser[]) {
        super();
        this.delimiters = delimiters;
        this.parsers = parsers;
    }
    public reinit () {
        this.delimiters.clear();
    }
    // Handle a delimiter marker for emphasis or a quote.
    public parse (parser : InlineContentParser, node : Node) : boolean {
        const cc = parser.peek();
        if (cc == undefined) {
            return false;
        }
        let dil = this.parsers.find((p) => {
            return p.getDelimiterCharacters().indexOf(cc) >= 0;
        });
        if (dil == undefined) {
            return false;
        }
        //console.log("found", dil.getDelimiterCharacterCodes());
        var res = this.scanDelims(parser, dil, cc);
        //console.log("res", res);
        if (!res) {
            return false;
        }
        var numdelims = res.numdelims;
        var startpos = parser.pos;

        parser.pos += numdelims;
        const contents = dil.getDelimiterContent(parser, startpos, cc);
        var text = parser.text(contents);
        node.appendChild(text);

        // Add entry to stack for this opener
        this.delimiters.push({
            cc: cc,
            numdelims: numdelims,
            origdelims: numdelims,
            node: text,
            can_open: res.can_open,
            can_close: res.can_close
        });

        return true;
    }
    public finalize () : void {
        this.processEmphasis(undefined);
    }
    // Scan a sequence of characters with code cc, and return information about
    // the number of delimiters and whether they are positioned such that
    // they can open and/or close emphasis or strong emphasis.  A utility
    // function for strong/emph parsing.
    scanDelims(parser : InlineContentParser, dil : DelimitedInlineSubParser, cc : string) {
        var char_before, char_after, cc_after;
        var startpos = parser.pos;

        dil.advanceDelimiter(parser, cc);
        let numdelims = parser.pos - startpos;
        //console.log("numdelims", numdelims);
        if (numdelims === 0) {
            return undefined;
        }

        char_before = startpos === 0 ? '\n' : parser.subject.charAt(startpos - 1);

        cc_after = parser.peek();
        if (cc_after == undefined) {
            char_after = '\n';
        } else {
            char_after = cc_after;
        }
        //console.log("char_after", char_after);

        const after_is_whitespace = reUnicodeWhitespaceChar.test(char_after);
        const after_is_punctuation = rePunctuation.test(char_after);
        const before_is_whitespace = reUnicodeWhitespaceChar.test(char_before);
        const before_is_punctuation = rePunctuation.test(char_before);

        const left_flanking = !after_is_whitespace &&
                (!after_is_punctuation || before_is_whitespace || before_is_punctuation);
        const right_flanking = !before_is_whitespace &&
                (!before_is_punctuation || after_is_whitespace || after_is_punctuation);
        const info = {
            beforeIsPunctuation : before_is_punctuation,
            afterIsPunctuation : after_is_punctuation,
            leftFlanking : left_flanking,
            rightFlanking : right_flanking
        };
        //console.log("info", info);
        const can_open = dil.canOpen(info, cc);
        //console.log("can_open", can_open);
        const can_close = dil.canClose(info, cc);
        //console.log("can_close", can_close);
        parser.pos = startpos;
        return {
            numdelims: numdelims,
            can_open: can_open,
            can_close: can_close,
        };
    };

    processEmphasis(stack_bottom : Delimiter|undefined) {
        let openers_bottom : {
            [character : string] : Delimiter|undefined
        } = {};

        for (let p of this.parsers) {
            for (let c of p.getDelimiterCharacters()) {
                openers_bottom[c] = stack_bottom;
            }
        }

        // find first closer above stack_bottom:
        let closer = this.delimiters.peek();
        while (closer != undefined && closer.previous !== stack_bottom) {
            closer = closer.previous;
        }
        // move forward, looking for closers, and handling each
        while (closer != undefined) {
            var closercc = closer.cc;
            if (!closer.can_close) {
                closer = closer.next;
            } else {
                // found emphasis closer. now look back for first matching opener:
                let opener = closer.previous;
                let opener_found = false;

                let odd_match : boolean = false;

                while (opener != undefined && opener !== stack_bottom &&
                       opener !== openers_bottom[closercc]) {
                    odd_match = (closer.can_open || opener.can_close) &&
                        (opener.origdelims + closer.origdelims) % 3 === 0;
                    if (opener.cc === closer.cc && opener.can_open && !odd_match) {
                        opener_found = true;
                        break;
                    }
                    opener = opener.previous;
                }
                let old_closer = closer;

                for (let p of this.parsers) {
                    if (p.getDelimiterCharacters().indexOf(closercc) >= 0) {
                        let args : ParseArgs|undefined = undefined;
                        if (opener_found) {
                            if (opener == undefined) {
                                throw new Error("Opener found but opener is undefined");
                            } else {
                                args = {
                                   delimiters : this.delimiters,
                                   openerFound : opener_found,
                                   opener : opener,
                                   closer : closer
                               };
                            }
                        } else {
                            args = {
                               delimiters : this.delimiters,
                               openerFound : opener_found,
                               opener : opener,
                               closer : closer
                           };
                        }

                        const parseResult = p.parse(args, closercc);
                        closer = parseResult.closer;
                        break;
                    }
                }

                if (!opener_found && !odd_match) {
                    // Set lower bound for future searches for openers:
                    // We don't do this with odd_match because a **
                    // that doesn't match an earlier * might turn into
                    // an opener, and the * might be matched by something
                    // else.
                    openers_bottom[closercc] = old_closer.previous;
                    if (!old_closer.can_open) {
                        // We can remove a closer that can't be an opener,
                        // once we've seen there's no matching opener:
                        this.delimiters.remove(old_closer);
                    }
                }
            }

        }

        // remove all delimiters
        while (this.delimiters.peek() != undefined && this.delimiters.peek() !== stack_bottom) {
            this.delimiters.remove(this.delimiters.peek());
        }
    };

}
