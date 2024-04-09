//
//  UIDocumentProvider.swift
//  CodeEdit
//
//  Created by Abe Malla on 4/5/24.
//

#if os(iOS)
import UIKit

final class UIDocumentProvider: DocumentProvider {
    private let fileManager = FileManager.default

    func addDocument(_ document: Document) {
        // TODO: Implement adding a document to the document list. Implementation should be like NSDocumentController.addDocument
    }

    func newDocument(_ sender: Any?) {
        let newDocument = Document(fileURL: newDocumentUrl())
        newDocument.save(to: newDocument.fileURL, for: .forCreating) { [weak self] success in
            if success {
                print("successfully created new document")
                self?.addDocument(newDocument)
            } else {
                print("Failed to create new document")
            }
        }
    }

    private func newDocumentUrl() -> URL {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentName = "CodeEditTestFile.txt"
        return documentDirectory.appendingPathComponent(documentName)
    }

    func openDocument(_ sender: Any?) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.plainText])
        documentPicker.shouldShowFileExtensions = true
        documentPicker.allowsMultipleSelection = false

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(documentPicker, animated: true, completion: nil)
        }
    }

    @objc(documentPicker:didPickDocumentsAtURLs:)
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        openDocument(withContentsOf: url, display: true) { [weak self] document, documentWasAlreadyOpen, error in
            if let document = document {
                self?.addDocument(document)
                self?.updateRecent(url)
            } else {
                let errorMessage = error?.localizedDescription ?? "unknown error"
                print("Unable to open document '\(url)': \(errorMessage)")
            }
        }
    }
    
    func openDocument(withContentsOf url: URL, display displayDocument: Bool, completionHandler: @escaping (Document?, Bool, Error?) -> Void) {
        updateRecent(url)
        
        let document = Document(fileURL: url)
        document.open { success in
            if success {
                completionHandler(document, false, nil)
            } else {
                completionHandler(nil, false, NSError(domain: "com.codeedit.documentprovider", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to open document"]))
            }
        }
    }
    
    func openDocument(onCompletion: @escaping (Document?, Bool) -> Void, onCancel: @escaping () -> Void) {
//        let dialog = NSOpenPanel()
//
//        dialog.title = "Open Workspace or File"
//        dialog.showsResizeIndicator = true
//        dialog.showsHiddenFiles = false
//        dialog.canChooseFiles = true
//        dialog.canChooseDirectories = true
//
//        dialog.begin { result in
//            if result == .OK, let url = dialog.url {
//                self.openDocument(withContentsOf: url, display: true) { document, documentWasAlreadyOpen, error in
//                    if let error = error {
//                        NSAlert(error: error).runModal()
//                        return
//                    }
//
//                    guard let document = document else {
//                        let alert = NSAlert()
//                        alert.messageText = NSLocalizedString(
//                            "Failed to get document",
//                            comment: "Failed to get document"
//                        )
//                        alert.runModal()
//                        return
//                    }
//                    onCompletion(document, documentWasAlreadyOpen)
//                    print("Document:", document)
//                    print("Was already open?", documentWasAlreadyOpen)
//                }
//            } else if result == .cancel {
//                onCancel()
//            }
//        }
    }
    
    func removeDocument(_ document: Document) {
        // TODO: Implement removing a document from the document list
    }
    
    func clearRecentDocuments(_ sender: Any?) {
        // TODO: Implement clearing recent documents
    }
    
    private func updateRecent(_ url: URL) {
        // TODO: Implement updating recent documents
    }
}
#endif
