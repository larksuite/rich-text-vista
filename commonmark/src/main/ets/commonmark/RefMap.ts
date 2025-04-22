export interface Reference {
    destination : string;
    title : string;
}
export type RefMap = {
    [k : string] : undefined|Reference
}
