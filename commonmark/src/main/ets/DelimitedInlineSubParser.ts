import {RegexStream} from "./RegexStream";
import {Delimiter, DelimiterCollection} from "./DelimiterCollection";

export interface DelimiterInfo {
    beforeIsPunctuation : boolean,
    afterIsPunctuation : boolean,
    leftFlanking : boolean,
    rightFlanking : boolean,
}

export type ParseArgs = (
    {
        delimiters : DelimiterCollection;
        openerFound : true;
        opener : Delimiter;
        closer : Delimiter;
    } |
    {
        delimiters : DelimiterCollection;
        openerFound : false;
        opener : Delimiter|undefined;
        closer : Delimiter;
    }
);
export interface ParseResult {
    closer : Delimiter|undefined,
}
export abstract class DelimitedInlineSubParser {
    public abstract getDelimiterCharacters () : string[];
    public abstract advanceDelimiter (stream : RegexStream, delimiter : string) : void;
    public abstract canOpen (info : DelimiterInfo, delimiter : string) : boolean;
    public abstract canClose (info : DelimiterInfo, delimiter : string) : boolean;

    public abstract getDelimiterContent (stream : RegexStream, delimiterStartPosition : number, delimiter : string) : string;
    public abstract parse (args : ParseArgs, delimiter : string) : ParseResult;
}
