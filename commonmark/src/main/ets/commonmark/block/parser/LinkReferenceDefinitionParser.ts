import {ParagraphContentParser} from "./ParagraphContentParser";
import {BlockParser} from "./../../../BlockParser";
import {Node} from "./../../../Node";
import {parseReference} from "./../../link-util";
import {RefMap} from "./../../RefMap";

export class LinkReferenceDefinitionParser extends ParagraphContentParser {
    private refMap : RefMap;
    public constructor (refMap : RefMap) {
        super();
        this.refMap = refMap;
    }
    public reinit () : void {
        for (let k of Object.keys(this.refMap)) {
            delete this.refMap[k];
        }
    }
    public parse (paragraphParser : BlockParser<Node>, paragraph : Node) : boolean {
        const content = paragraphParser.getString(paragraph);

        if (content[0] != "[") {
            return false;
        }
        const pos = parseReference(content, this.refMap);
        if (pos == 0) {
            return false;
        }

        paragraphParser.setString(paragraph, content.slice(pos));
        return true;
    }
}
