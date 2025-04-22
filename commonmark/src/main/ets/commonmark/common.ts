"use strict";

import * as encode from "mdurl/encode";
import * as decode from "mdurl/decode";

const decodeHTML = require('entities').decodeHTML;

export const ENTITY = "&(?:#x[a-f0-9]{1,8}|#[0-9]{1,8}|[a-z][a-z0-9]{1,31});";

const TAGNAME = '[A-Za-z][A-Za-z0-9-]*';
const ATTRIBUTENAME = '[a-zA-Z_:][a-zA-Z0-9:._-]*';
const UNQUOTEDVALUE = "[^\"'=<>`\\x00-\\x20]+";
const SINGLEQUOTEDVALUE = "'[^']*'";
const DOUBLEQUOTEDVALUE = '"[^"]*"';
const ATTRIBUTEVALUE = "(?:" + UNQUOTEDVALUE + "|" + SINGLEQUOTEDVALUE + "|" + DOUBLEQUOTEDVALUE + ")";
const ATTRIBUTEVALUESPEC = "(?:" + "\\s*=" + "\\s*" + ATTRIBUTEVALUE + ")";
const ATTRIBUTE = "(?:" + "\\s+" + ATTRIBUTENAME + ATTRIBUTEVALUESPEC + "?)";
export const OPENTAG = "<" + TAGNAME + ATTRIBUTE + "*" + "\\s*/?>";
export const CLOSETAG = "</" + TAGNAME + "\\s*[>]";
const HTMLCOMMENT = "<!---->|<!--(?:-?[^>-])(?:-?[^-])*-->";
const PROCESSINGINSTRUCTION = "[<][?].*?[?][>]";
const DECLARATION = "<![A-Z]+" + "\\s+[^>]*>";
const CDATA = "<!\\[CDATA\\[[\\s\\S]*?\\]\\]>";
const HTMLTAG = "(?:" + OPENTAG + "|" + CLOSETAG + "|" + HTMLCOMMENT + "|" +
        PROCESSINGINSTRUCTION + "|" + DECLARATION + "|" + CDATA + ")";
export const reHtmlTag = new RegExp('^' + HTMLTAG, 'i');

const reBackslashOrAmp = /[\\&]/;

export const ESCAPABLE = '[!"#$%&\'()*+,./:;<=>?@[\\\\\\]^_`{|}~-]';

const reEntityOrEscapedChar = new RegExp('\\\\' + ESCAPABLE + '|' + ENTITY, 'gi');

const XMLSPECIAL = '[&<>"]';

const reXmlSpecial = new RegExp(XMLSPECIAL, 'g');

const reXmlSpecialOrEntity = new RegExp(ENTITY + '|' + XMLSPECIAL, 'gi');

const unescapeChar = function(s : string) {
    if (s[0] == "\\") {
        return s.charAt(1);
    } else {
        return decodeHTML(s);
    }
};

// Replace entities and backslash escapes with literal characters.
export const unescapeString = function(s : string) {
    if (reBackslashOrAmp.test(s)) {
        return s.replace(reEntityOrEscapedChar, unescapeChar);
    } else {
        return s;
    }
};

export const normalizeURI = function(uri : string) {
    try {
        return encode(decode(uri));
    }
    catch(err) {
        return uri;
    }
};

const replaceUnsafeChar = function(s : string) {
    switch (s) {
    case '&':
        return '&amp;';
    case '<':
        return '&lt;';
    case '>':
        return '&gt;';
    case '"':
        return '&quot;';
    default:
        return s;
    }
};

export const escapeXml = function(s : string, preserve_entities? : boolean) {
    if (reXmlSpecial.test(s)) {
        if (preserve_entities) {
            return s.replace(reXmlSpecialOrEntity, replaceUnsafeChar);
        } else {
            return s.replace(reXmlSpecial, replaceUnsafeChar);
        }
    } else {
        return s;
    }
};
