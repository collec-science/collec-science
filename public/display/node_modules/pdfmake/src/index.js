const pdfmakeBase = require('./base').default;
const OutputDocumentServer = require('./OutputDocumentServer').default;

class pdfmake extends pdfmakeBase {
	constructor() {
		super();
	}

	/**
	 * @param {(path: string) => boolean} callback
	 */
	setLocalAccessPolicy(callback) {
		if (callback !== undefined && typeof callback !== 'function') {
			throw new Error("Parameter 'callback' has an invalid type. Function or undefined expected.");
		}

		this.localAccessPolicy = callback;
	}

	_transformToDocument(doc) {
		return new OutputDocumentServer(doc);
	}
}

module.exports = new pdfmake();
