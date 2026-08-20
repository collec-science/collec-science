"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.XmlDocument = exports.XmlElement = exports.XmlCommentNode = exports.XmlCDataNode = exports.XmlTextNode = void 0;
const sax_1 = __importDefault(require("sax"));
/**
 * Represents a text node in an XML document
 */
class XmlTextNode {
    /**
     * Creates a new text node
     * @param text The text content
     */
    constructor(text) {
        this.text = text;
        this.type = "text";
    }
    /**
     * Converts the text node to a string
     * @param options Formatting options
     * @returns String representation of the text node
     */
    toString(options) {
        return formatText(escapeXML(this.text), options);
    }
    /**
     * Converts the text node to a string with indentation
     * @param indent The indentation to use
     * @param options Formatting options
     * @returns String representation of the text node with indentation
     */
    toStringWithIndent(indent, options) {
        return indent + this.toString(options);
    }
}
exports.XmlTextNode = XmlTextNode;
/**
 * Represents a CDATA node in an XML document
 */
class XmlCDataNode {
    /**
     * Creates a new CDATA node
     * @param cdata The CDATA content
     */
    constructor(cdata) {
        this.cdata = cdata;
        this.type = "cdata";
    }
    /**
     * Converts the CDATA node to a string
     * @param options Formatting options
     * @returns String representation of the CDATA node
     */
    toString(options) {
        return `<![CDATA[${formatText(this.cdata, options)}]]>`;
    }
    /**
     * Converts the CDATA node to a string with indentation
     * @param indent The indentation to use
     * @param options Formatting options
     * @returns String representation of the CDATA node with indentation
     */
    toStringWithIndent(indent, options) {
        return indent + this.toString(options);
    }
}
exports.XmlCDataNode = XmlCDataNode;
/**
 * Represents a comment node in an XML document
 */
class XmlCommentNode {
    /**
     * Creates a new comment node
     * @param comment The comment content
     */
    constructor(comment) {
        this.comment = comment;
        this.type = "comment";
    }
    /**
     * Converts the comment node to a string
     * @param options Formatting options
     * @returns String representation of the comment node
     */
    toString(options) {
        return `<!--${formatText(escapeXML(this.comment), options)}-->`;
    }
    /**
     * Converts the comment node to a string with indentation
     * @param indent The indentation to use
     * @param options Formatting options
     * @returns String representation of the comment node with indentation
     */
    toStringWithIndent(indent, options) {
        return indent + this.toString(options);
    }
}
exports.XmlCommentNode = XmlCommentNode;
/**
 * Represents an XML element node with children
 */
class XmlElement {
    /**
     * Creates a new XML element
     * @param tag The tag name and attributes
     * @param parser Optional SAX parser instance with position information
     */
    constructor(tag, parser) {
        this.type = "element";
        // If you didn't hand us a parser (common case) see if we can grab one
        // from the current execution stack.
        if (!parser && delegates.length) {
            var delegate = delegates[delegates.length - 1];
            if ("parser" in delegate) {
                parser = delegate.parser;
            }
        }
        this.name = tag.name;
        this.attr = tag.attributes;
        this.val = "";
        this.children = [];
        this.firstChild = null;
        this.lastChild = null;
        // Assign parse information
        this.line = parser ? parser.line : null;
        this.column = parser ? parser.column : null;
        this.position = parser ? parser.position : null;
        this.startTagPosition = parser ? parser.startTagPosition : null;
    }
    /**
     * Adds a child node to this element
     * @param child The child node to add
     */
    _addChild(child) {
        // add to our children array
        this.children.push(child);
        // update first/last pointers
        if (!this.firstChild)
            this.firstChild = child;
        this.lastChild = child;
    }
    _opentag(tag) {
        const child = new XmlElement(tag);
        this._addChild(child);
        delegates.unshift(child);
    }
    _closetag() {
        delegates.shift();
    }
    _text(text) {
        this.val += text;
        this._addChild(new XmlTextNode(text));
    }
    _cdata(cdata) {
        this.val += cdata;
        this._addChild(new XmlCDataNode(cdata));
    }
    _comment(comment) {
        this._addChild(new XmlCommentNode(comment));
    }
    _error(err) {
        throw err;
    }
    /**
     * Iterates through each child element of this node
     * @param iterator Function to call for each child element
     * @param context Optional context to use for the iterator function
     */
    eachChild(iterator, context) {
        for (let i = 0, l = this.children.length; i < l; i++) {
            const child = this.children[i];
            if (child.type === "element") {
                if (iterator.call(context, child, i, this.children) ===
                    false)
                    return;
            }
        }
    }
    /**
     * Finds the first child element with the given name
     * @param name The name of the child element to find
     * @returns The first matching child element, or undefined if not found
     */
    childNamed(name) {
        for (let i = 0, l = this.children.length; i < l; i++) {
            const child = this.children[i];
            if (child.type === "element" && child.name === name) {
                return child;
            }
        }
        return undefined;
    }
    /**
     * Finds all child elements with the given name
     * @param name The name of the child elements to find
     * @returns Array of matching child elements
     */
    childrenNamed(name) {
        const matches = [];
        for (let i = 0, l = this.children.length; i < l; i++) {
            const child = this.children[i];
            if (child.type === "element" && child.name === name) {
                matches.push(child);
            }
        }
        return matches;
    }
    /**
     * Finds the first child element with the given attribute
     * @param name The name of the attribute to find
     * @param value Optional value the attribute should have
     * @returns The first matching child element, or undefined if not found
     */
    childWithAttribute(name, value) {
        for (let i = 0, l = this.children.length; i < l; i++) {
            const child = this.children[i];
            if (child.type === "element" &&
                ((value !== undefined && child.attr[name] === value) ||
                    (value === undefined && child.attr[name]))) {
                return child;
            }
        }
        return undefined;
    }
    /**
     * Finds all descendant elements with the given name, searching recursively
     * @param name The name of the descendant elements to find
     * @returns Array of matching descendant elements
     */
    descendantsNamed(name) {
        const matches = [];
        for (let i = 0, l = this.children.length; i < l; i++) {
            const child = this.children[i];
            if (child.type === "element") {
                const element = child;
                if (element.name === name)
                    matches.push(element);
                matches.push(...element.descendantsNamed(name));
            }
        }
        return matches;
    }
    /**
     * Finds a descendant element using a dot-notation path
     * @param path The path to the descendant, e.g. "author.name"
     * @returns The matching descendant element, or undefined if not found
     * @example
     * // For XML: <book><author><name>John</name></author></book>
     * bookNode.descendantWithPath("author.name") // returns the <name> element
     */
    descendantWithPath(path) {
        let descendant = this;
        const components = path.split(".");
        for (let i = 0, l = components.length; i < l; i++) {
            if (descendant && descendant.type === "element") {
                descendant = descendant.childNamed(components[i]);
            }
            else {
                return undefined;
            }
        }
        return descendant;
    }
    /**
     * Gets the value of a descendant element or attribute using a path
     * @param path The path to the descendant or attribute, e.g. "author.name" or "author.name@id"
     * @returns The value of the descendant or attribute, or undefined if not found
     * @example
     * // For XML: <book><author><name id="1">John</name></author></book>
     * bookNode.valueWithPath("author.name")    // returns "John"
     * bookNode.valueWithPath("author.name@id") // returns "1"
     */
    valueWithPath(path) {
        const components = path.split("@");
        const descendant = this.descendantWithPath(components[0]);
        if (descendant) {
            return components.length > 1
                ? descendant.attr[components[1]]
                : descendant.val;
        }
        else {
            return undefined;
        }
    }
    /**
     * Converts the element to a string representation
     * @param options Formatting options
     * @returns String representation of the element
     */
    toString(options) {
        return this.toStringWithIndent("", options);
    }
    /**
     * Converts the element to a string with the specified indentation
     * @param indent The indentation to use
     * @param options Formatting options
     * @returns String representation of the element with indentation
     */
    toStringWithIndent(indent, options) {
        let s = `${indent}<${this.name}`;
        const linebreak = (options === null || options === void 0 ? void 0 : options.compressed) ? "" : "\n";
        for (const name in this.attr) {
            if (Object.prototype.hasOwnProperty.call(this.attr, name)) {
                s += ` ${name}="${escapeXML(this.attr[name])}"`;
            }
        }
        if (this.children.length === 1 && this.children[0].type !== "element") {
            s += `>${this.children[0].toString(options)}</${this.name}>`;
        }
        else if (this.children.length) {
            s += `>${linebreak}`;
            const childIndent = indent + ((options === null || options === void 0 ? void 0 : options.compressed) ? "" : "  ");
            for (let i = 0, l = this.children.length; i < l; i++) {
                s += `${this.children[i].toStringWithIndent(childIndent, options)}${linebreak}`;
            }
            s += `${indent}</${this.name}>`;
        }
        else if (options === null || options === void 0 ? void 0 : options.html) {
            const whiteList = [
                "area",
                "base",
                "br",
                "col",
                "embed",
                "frame",
                "hr",
                "img",
                "input",
                "keygen",
                "link",
                "menuitem",
                "meta",
                "param",
                "source",
                "track",
                "wbr",
            ];
            if (whiteList.includes(this.name)) {
                s += "/>";
            }
            else {
                s += `></${this.name}>`;
            }
        }
        else {
            s += "/>";
        }
        return s;
    }
}
exports.XmlElement = XmlElement;
/**
 * The main XML document class - the entry point for parsing XML
 */
class XmlDocument extends XmlElement {
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
    constructor(xml) {
        // Initialize with a dummy tag that will be replaced
        super({ name: "", attributes: {} });
        xml = xml.toString().trim();
        if (!xml) {
            throw new Error("No XML to parse!");
        }
        // Stores doctype (if defined)
        this.doctype = "";
        // Expose the parser to the other delegates while the parser is running
        this.parser = sax_1.default.parser(true); // strict
        addParserEvents(this.parser);
        // Initialize delegates with this document
        delegates = [this];
        try {
            this.parser.write(xml);
        }
        finally {
            // Remove the parser as it is no longer needed
            delete this.parser;
        }
    }
    _opentag(tag) {
        if (this.name === "") {
            // First tag becomes the root - we'll update our own properties
            this.name = tag.name;
            this.attr = tag.attributes;
        }
        else {
            // All other tags will be the root element's children
            super._opentag(tag);
        }
    }
    _doctype(doctype) {
        this.doctype += doctype;
    }
}
exports.XmlDocument = XmlDocument;
// Helper variables and functions
let delegates = [];
function addParserEvents(parser) {
    parser.onopentag = (tag) => { var _a; return (_a = delegates[0]) === null || _a === void 0 ? void 0 : _a._opentag(tag); };
    parser.onclosetag = () => { var _a; return (_a = delegates[0]) === null || _a === void 0 ? void 0 : _a._closetag(); };
    parser.ontext = (text) => { var _a; return (_a = delegates[0]) === null || _a === void 0 ? void 0 : _a._text(text); };
    parser.oncdata = (cdata) => { var _a; return (_a = delegates[0]) === null || _a === void 0 ? void 0 : _a._cdata(cdata); };
    parser.oncomment = (comment) => { var _a; return (_a = delegates[0]) === null || _a === void 0 ? void 0 : _a._comment(comment); };
    parser.ondoctype = (doctype) => {
        const doc = delegates[0];
        if (doc._doctype)
            doc._doctype(doctype);
    };
    parser.onerror = (err) => { var _a; return (_a = delegates[0]) === null || _a === void 0 ? void 0 : _a._error(err); };
}
/**
 * Escapes XML special characters
 * @param value The string to escape
 * @returns The escaped string
 */
function escapeXML(value) {
    return value
        .toString()
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/'/g, "&apos;")
        .replace(/"/g, "&quot;");
}
/**
 * Formats text for display according to the given options
 * @param text The text to format
 * @param options Formatting options
 * @returns The formatted text
 */
function formatText(text, options) {
    let finalText = text;
    if ((options === null || options === void 0 ? void 0 : options.trimmed) && text.length > 25) {
        finalText = finalText.substring(0, 25).trim() + "…";
    }
    if (!(options === null || options === void 0 ? void 0 : options.preserveWhitespace)) {
        finalText = finalText.trim();
    }
    return finalText;
}
// Export main classes
exports.default = XmlDocument;
//# sourceMappingURL=xmldoc.js.map