import { SAXParser } from "sax";
/**
 * Options for XML string output formatting
 */
export interface XmlStringOptions {
    /** Remove indentation and linebreaks when outputting XML */
    compressed?: boolean;
    /** Truncate long string values for easier debugging */
    trimmed?: boolean;
    /** Prevent whitespace from being removed around element values */
    preserveWhitespace?: boolean;
    /** Use HTML self-closing tag rules for elements without children */
    html?: boolean;
}
/**
 * Base interface for all XML node types
 */
export interface XmlNodeBase {
    /** The type of node (element, text, cdata, comment) */
    type: string;
    /**
     * Converts the node to a string representation
     * @param options Formatting options
     * @returns String representation of the node
     */
    toString(options?: XmlStringOptions): string;
    /**
     * Converts the node to a string with the specified indentation
     * @param indent The indentation to use
     * @param options Formatting options
     * @returns String representation of the node with indentation
     */
    toStringWithIndent(indent: string, options?: XmlStringOptions): string;
}
interface XmlDelegate {
    _opentag(tag: {
        name: string;
        attributes: Record<string, string>;
    }): void;
    _closetag(): void;
    _text(text: string): void;
    _cdata(cdata: string): void;
    _comment(comment: string): void;
    _error(err: Error): void;
}
/**
 * Represents a text node in an XML document
 */
export declare class XmlTextNode implements XmlNodeBase {
    text: string;
    readonly type = "text";
    /**
     * Creates a new text node
     * @param text The text content
     */
    constructor(text: string);
    /**
     * Converts the text node to a string
     * @param options Formatting options
     * @returns String representation of the text node
     */
    toString(options?: XmlStringOptions): string;
    /**
     * Converts the text node to a string with indentation
     * @param indent The indentation to use
     * @param options Formatting options
     * @returns String representation of the text node with indentation
     */
    toStringWithIndent(indent: string, options?: XmlStringOptions): string;
}
/**
 * Represents a CDATA node in an XML document
 */
export declare class XmlCDataNode implements XmlNodeBase {
    cdata: string;
    readonly type = "cdata";
    /**
     * Creates a new CDATA node
     * @param cdata The CDATA content
     */
    constructor(cdata: string);
    /**
     * Converts the CDATA node to a string
     * @param options Formatting options
     * @returns String representation of the CDATA node
     */
    toString(options?: XmlStringOptions): string;
    /**
     * Converts the CDATA node to a string with indentation
     * @param indent The indentation to use
     * @param options Formatting options
     * @returns String representation of the CDATA node with indentation
     */
    toStringWithIndent(indent: string, options?: XmlStringOptions): string;
}
/**
 * Represents a comment node in an XML document
 */
export declare class XmlCommentNode implements XmlNodeBase {
    comment: string;
    readonly type = "comment";
    /**
     * Creates a new comment node
     * @param comment The comment content
     */
    constructor(comment: string);
    /**
     * Converts the comment node to a string
     * @param options Formatting options
     * @returns String representation of the comment node
     */
    toString(options?: XmlStringOptions): string;
    /**
     * Converts the comment node to a string with indentation
     * @param indent The indentation to use
     * @param options Formatting options
     * @returns String representation of the comment node with indentation
     */
    toStringWithIndent(indent: string, options?: XmlStringOptions): string;
}
/**
 * Represents an XML element node with children
 */
export declare class XmlElement implements XmlNodeBase, XmlDelegate {
    readonly type = "element";
    /** The node name, like "tat" for <tat> */
    name: string;
    /** An object containing attributes, like bookNode.attr.title for <book title="..."> */
    attr: Record<string, string>;
    /** The string value of the node, like "world" for <hello>world</hello> */
    val: string;
    /** Array of child nodes */
    children: XmlNodeBase[];
    /** The first child node, or null if no children */
    firstChild: XmlNodeBase | null;
    /** The last child node, or null if no children */
    lastChild: XmlNodeBase | null;
    /** Line number of the element in the original XML */
    line: number | null;
    /** Column number of the element in the original XML */
    column: number | null;
    /** Character position of the element in the original XML */
    position: number | null;
    /** Character position of the start tag in the original XML */
    startTagPosition: number | null;
    /**
     * Creates a new XML element
     * @param tag The tag name and attributes
     * @param parser Optional SAX parser instance with position information
     */
    constructor(tag: {
        name: string;
        attributes: Record<string, string>;
    }, parser?: SAXParser);
    /**
     * Adds a child node to this element
     * @param child The child node to add
     */
    protected _addChild(child: XmlNodeBase): void;
    _opentag(tag: {
        name: string;
        attributes: Record<string, string>;
    }): void;
    _closetag(): void;
    _text(text: string): void;
    _cdata(cdata: string): void;
    _comment(comment: string): void;
    _error(err: Error): void;
    /**
     * Iterates through each child element of this node
     * @param iterator Function to call for each child element
     * @param context Optional context to use for the iterator function
     */
    eachChild(iterator: (child: XmlElement, index: number, array: XmlNodeBase[]) => boolean | void, context?: any): void;
    /**
     * Finds the first child element with the given name
     * @param name The name of the child element to find
     * @returns The first matching child element, or undefined if not found
     */
    childNamed(name: string): XmlElement | undefined;
    /**
     * Finds all child elements with the given name
     * @param name The name of the child elements to find
     * @returns Array of matching child elements
     */
    childrenNamed(name: string): XmlElement[];
    /**
     * Finds the first child element with the given attribute
     * @param name The name of the attribute to find
     * @param value Optional value the attribute should have
     * @returns The first matching child element, or undefined if not found
     */
    childWithAttribute(name: string, value?: string): XmlElement | undefined;
    /**
     * Finds all descendant elements with the given name, searching recursively
     * @param name The name of the descendant elements to find
     * @returns Array of matching descendant elements
     */
    descendantsNamed(name: string): XmlElement[];
    /**
     * Finds a descendant element using a dot-notation path
     * @param path The path to the descendant, e.g. "author.name"
     * @returns The matching descendant element, or undefined if not found
     * @example
     * // For XML: <book><author><name>John</name></author></book>
     * bookNode.descendantWithPath("author.name") // returns the <name> element
     */
    descendantWithPath(path: string): XmlElement | undefined;
    /**
     * Gets the value of a descendant element or attribute using a path
     * @param path The path to the descendant or attribute, e.g. "author.name" or "author.name@id"
     * @returns The value of the descendant or attribute, or undefined if not found
     * @example
     * // For XML: <book><author><name id="1">John</name></author></book>
     * bookNode.valueWithPath("author.name")    // returns "John"
     * bookNode.valueWithPath("author.name@id") // returns "1"
     */
    valueWithPath(path: string): string | undefined;
    /**
     * Converts the element to a string representation
     * @param options Formatting options
     * @returns String representation of the element
     */
    toString(options?: XmlStringOptions): string;
    /**
     * Converts the element to a string with the specified indentation
     * @param indent The indentation to use
     * @param options Formatting options
     * @returns String representation of the element with indentation
     */
    toStringWithIndent(indent: string, options?: XmlStringOptions): string;
}
interface XmlDocumentDelegate extends XmlDelegate {
    _doctype(doctype: string): void;
}
/**
 * The main XML document class - the entry point for parsing XML
 */
export declare class XmlDocument extends XmlElement implements XmlDocumentDelegate {
    /** The document's doctype declaration, if any */
    doctype: string;
    /** The SAX parser instance (available only during parsing) */
    parser?: SAXParser;
    /**
     * Creates a new XML document from an XML string
     * @param xml The XML string to parse
     * @throws {Error} If the XML is empty or invalid
     * @example
     * ```ts
     * import { XmlDocument } from 'xmldoc';
     *
     * const doc = new XmlDocument("<root><child>value</child></root>");
     * console.log(doc.childNamed("child")?.val); // "value"
     * ```
     */
    constructor(xml: string);
    _opentag(tag: {
        name: string;
        attributes: Record<string, string>;
    }): void;
    _doctype(doctype: string): void;
}
export default XmlDocument;
