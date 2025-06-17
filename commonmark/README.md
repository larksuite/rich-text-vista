# `commonmark`

This package is a mirror of [flavormark](https://github.com/AnyhowStep/flavormark), originally developed for standard
Markdown processing. It is now published in
the OpenHarmony Third-party Library Central Repository to provide easier access for HarmonyOS app developers.

Based on [commonmark.js](https://github.com/commonmark/commonmark.js)

FlavorMark is a Markdown parser, made in TypeScript, with emphasis placed on modularizing
element parsing logic, making it easy(-ish) to add/remove syntax for your favorite Markdown flavors.

## Parsers

There are a lot of classes with the word `Parser` in them.

+ `Parser`

  The main parser, parses block elements. Then, parses inline content.

+ `BlockParser`

  Each block element will generally be parsed by one `BlockParser`.

+ `InlineContentParser`

  Parses inline content, using `InlineParser`.

+ `InlineParser`

  Each inline element will generally be parsed by one `InlineParser`.

+ `DelimitedInlineParser`

  This parser makes it easier to parse inline elements that behave like emphasis
  elements.

+ `DelimitedInlineSubParser`

  If using `DelimitedInlineParser`, each sub-parser will parse one emphasis-like
  element. (Emphasis, smart quotes, superscript, strikethrough, etc.)

## 📦 Installation

Install via ohpm:

```
# Using ohpm install
ohpm install commonmark

# Or using the shortcut (ohpm i)
ohpm i commonmark
```

## Usage

1. Instantiate all `BlockParser` classes and add them to a `BlockParserCollection`.
2. Instantiate all `InlineParser` classes and add them to an array.
3. Instantiate an `InlineContentParser` and pass it the array of `InlineParser`.
4. Instantiate a `Parser` and pass it the `BlockParserCollection`, and `InlineContentParser`.
5. Call `Parser.parse(str)`.

See the tests in `src/test` for more examples.

## Notes

Each `Node` constructor is used to uniquely identify `BlockParser`, and `HtmlSubRenderer`
instances.

When trying to parse a block, `instanceof` checks are used to find the `BlockParser`
associated with a `Node`. The first matching `BlockParser` in the array is used.

For this reason, each unique block type should have its own `Node` sub-class.

# License

See `LICENSE` file (copy-pasted from `commonmark.js`).
Also, since this is just a glorified port of `commonmark.js`,
I guess the BSD-license carries over. I have no idea how this works. I don't really
care, personally. I just don't want to step on anyone's toes.
