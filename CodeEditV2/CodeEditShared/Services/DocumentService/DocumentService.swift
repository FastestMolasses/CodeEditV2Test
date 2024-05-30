//
//  DocumentService.swift
//  CodeEditV2
//
//  Created by Abe Malla on 3/21/24.
//

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif
import SwiftUI

#if os(macOS)
typealias Document = NSDocument
#elseif os(iOS)
class Document: UIDocument {
    var content: String = ""
    
    override func contents(forType typeName: String) throws -> Any {
        return content.data(using: .utf8) ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let data = contents as? Data {
            content = String(data: data, encoding: .utf8) ?? ""
        }
    }
}
#endif

protocol DocumentProvider {
    func addDocument(_ document: Document)
    func newDocument(_ sender: Any?)
    func openDocument(_ sender: Any?)
    func openDocument(withContentsOf url: URL, display displayDocument: Bool, completionHandler: @escaping (Document?, Bool, Error?) -> Void)
    func openDocument(onCompletion: @escaping (Document?, Bool) -> Void, onCancel: @escaping () -> Void)
    func removeDocument(_ document: Document)
    func clearRecentDocuments(_ sender: Any?)
}

final class DocumentService {
    private let documentProvider: DocumentProvider
    
    init() {
#if os(macOS)
        self.documentProvider = NSDocumentProvider()
#elseif os(iOS)
        self.documentProvider = UIDocumentProvider()
#endif
    }

    func newDocument(_ sender: Any? = nil) {
        documentProvider.newDocument(sender)
    }

    func openDocument(_ sender: Any? = nil) {
        documentProvider.openDocument(sender)
    }

    func openDocument(withContentsOf url: URL, display displayDocument: Bool, completionHandler: @escaping (Document?, Bool, Error?) -> Void) {
        documentProvider.openDocument(withContentsOf: url, display: displayDocument, completionHandler: completionHandler)
    }

    func openDocument(onCompletion: @escaping (Document?, Bool) -> Void, onCancel: @escaping () -> Void) {
        documentProvider.openDocument(onCompletion: onCompletion, onCancel: onCancel)
    }

    func removeDocument(_ document: Document) {
        documentProvider.removeDocument(document)
    }

    func clearRecentDocuments(_ sender: Any? = nil) {
        documentProvider.clearRecentDocuments(sender)
    }
}
