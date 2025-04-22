export function isSpaceOrTab (c : string) {
    return c == " " || c == "\t";
}

//Returns true if string is empty or contains only space characters.
export function isBlank (s : string) {
    return /^[ \t\f\v\r\n]*$/.test(s);
}
