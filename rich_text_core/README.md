RichTextVista
=============

RichTextVista is a high-performance, extensible rich text component designed for HarmonyOS applications, supporting diverse rich text styling capabilities. Named for its ability to render content with panoramic clarity, RichTextVista ensures every detail of the text shines in harmony (HarmonyOS).

Feature
-------

### **Core Text Formatting**

**Basic Styles** 

Supports basic text styles including bold, italic, underline, and strikethrough formatting, with paragraph separation capabilities. 

**Advanced Styles** 

Enables inline code blocks, custom text/background color customization, and precise control over line/character spacing.

### **Layout Capabilities**

Provides structured content presentation through ordered/unordered lists, hyperlink embedding, and image-text hybrid layouts. Supports embedding user-defined components for time-sensitive content display, allowing integration of RichTextVista within third-party elements.

### **Performance & Adaptation**

Delivers high rendering performance in lists through optimized pipelines. Supports foldable screens and PC devices while maintaining UI component reuse efficiency.

### **Extensibility**

Complies with CommonMark standards.

Project Structure
-----------------

The project structure is organized into several key directories in the root folder, each serving a specific purpose:

- **commonmark**: Contains Markdown standardized definitions, ensuring compliance with CommonMark standards.
- **entry**: A demo project utilizing RichTextVista to showcase its capabilities and provide example implementations.
- **rich_text_core**: Houses the core logic of RichTextVista, including the main functionalities and features.

The complete feature set and code structure are organized and explained in the figure below:

![Project Structure](https://github.com/larksuite/rich-text-vista/blob/main/project-structure.png)

Usage
-----
RichTextVista accepts multiple standard formats (raw string, HTML, Markdown) while exposing its Markdown-based Abstract Syntax Tree (AST) specification, enabling users to independently transform custom data structures into this canonical representation – ensuring seamless integration across flexible scenarios through unified processing.

**How RichTextVista Works**

The flexibility of RichTextVista allows you to work with various input formats, making it easy to integrate with different content sources. Whether you start from scratch by building the AST directly, or feed the component with HTML or Markdown strings, the parsing process converts the input into a unified AST (Node) representation. This AST is then used to render the rich text UI, ensuring consistent and accurate display of your content. The ability to implement custom styles further enhances the adaptability of the component, allowing for tailored text presentations that meet specific design requirements.

### Start with AST Input / Start from Scratch

You can build the rich text directly by constructing the AST (Abstract Syntax Tree) nodes. This approach allows you to have full control over the structure and styling of the text. It is most useful when you do not have a standardized format as your initial input, so it is best to build directly from this standardized AST. You start by creating Node objects and assembling them into a tree, which represents the rich text.

```
@Param content: Node  

build() {
  RichTextVista({      
    richText: this.createRichTextFromAST(),
    fontSize: 16,      
  })  
} 

private createRichTextFromAST() {
  const richTextRepresentation = new RichTextRepresentation()
  richTextRepresentation.ast = this.content
  return richTextRepresentation
}
```

### Start with String Input

For the most basic usage, you can start with a pure string input without any advanced styling. Simply provide the raw string to the component, and it will handle converting it into an AST (Node). This approach is ideal for scenarios where you have plain text content that you want to display as rich text.

```
// Assuming ComponentV2 

@Param content: string

build() {
  RichTextVista({      
    richText: this.createRichTextFromAST(),
    fontSize: 16,      
  })   
}

private parsePureTextToAST(content: string): RichTextRepresentation {
  const richTextRepresentation = new RichTextRepresentation()
  richTextRepresentation.plainText = content
  return richTextRepresentation
}
```

### Start with HTML String Input

If you have an HTML string, you can feed it directly to the component. The component will parse the HTML string and convert it into an AST (Node), which is then used to render the rich text UI. This method is convenient when you have existing HTML content that you want to display as rich text.

```
// Assuming ComponentV1  

@Prop content: string

build() {
  RichTextVista({      
    richText: this.parseHTMLStringToAST(this.content),
    fontSize: 16,      
  })   
}

private parseHtmlStringToAST(htmlContent: string): RichTextRepresentation {
  const richTextRepresentation = new RichTextRepresentation()
  richTextRepresentation.htmlString = htmlContent
  return richTextRepresentation
}
```

### Start with Markdown String Input

For Markdown input, simply provide the Markdown string to the component. The component will handle parsing the Markdown syntax and converting it into an AST (Node). This approach is ideal for scenarios where you have content written in Markdown format and want to display it as rich text.

```
// Assuming ComponentV1  

@Prop content: string

build() {
  RichTextVista({      
    richText: this.parseHTMLStringToAST(this.content),
    fontSize: 16,      
  })   
}

private parseMarkdownStringToAST(markdownContent: string): RichTextRepresentation {
  const richTextRepresentation = new RichTextRepresentation()
  richTextRepresentation.markdownString = markdownContent
  return richTextRepresentation
}
```

### Implement Custom Styles

RichTextVista not only supports pre-built common styles but also allows users to implement custom styles. If you want to display text styles that are not within the pre-built options, implementing a custom style is the best approach. This flexibility is particularly valuable, as supporting custom styles in rich text components can be quite challenging. To implement a custom style, refer to [EXTENSION](https://github.com/larksuite/rich-text-vista/blob/main/EXTENSION.md).

Future Plans
------------

**Format Enhancement & Layout Capabilities**

Add support for video embedding, table layouts, code block syntax highlighting, and other rich text styles. Strengthen mixed-format composition capabilities.

**Modular Styling Extensions**

Introduce official extension packages with pre-built style templates (headers, code themes, etc.), while enabling granular customization of fonts/colors through a plugin architecture.

**Sustained Performance Improvements**

Optimize parsing-rendering pipelines to handle complex nested elements, with memory-efficient operations and high frame rate rendering in scroll-intensive scenarios.

**Rich Text Editor with Core Features**

Develop an embeddable text editor supporting basic formatting, image insertion, paragraph/list creation, and keyboard shortcuts. Focus on smooth input interaction and deep collaborative integration with native platform APIs.

License
-------

MIT License. See [LICENSE](https://github.com/larksuite/rich-text-vista/blob/main/LICENSE) for details.

Acknowledgments
---------------

*   **HarmonyOS Team**: For collaborating on resolving system API limitations.
    
*   **Lark App IM Team**: For their guidance and suggestions throughout the development process.