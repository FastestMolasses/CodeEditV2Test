//
//  NSDocumentProvider.swift
//  CodeEdit
//
//  Created by Abe Malla on 4/5/24.
//

#if os(macOS)
import Cocoa

final class NSDocumentProvider: NSDocumentController, DocumentProvider {
    private let documentController = NSDocumentController.shared
    private let fileManager = FileManager.default

    override func newDocument(_ sender: Any?) {
        guard let newDocumentUrl = self.newDocumentUrl else { return }
        
        let createdFile = self.fileManager.createFile(
            atPath: newDocumentUrl.path,
            contents: nil,
            attributes: [FileAttributeKey.creationDate: Date()]
        )
        guard createdFile else {
            print("Failed to create new document")
            return
        }
        
        self.openDocument(withContentsOf: newDocumentUrl, display: true) { _, _, _ in }
    }

    private var newDocumentUrl: URL? {
        let panel = NSSavePanel()
        guard panel.runModal() == .OK else {
            return nil
        }
        return panel.url
    }
    
    override func openDocument(_ sender: Any?) {
        self.openDocument(onCompletion: { document, documentWasAlreadyOpen in
            // TODO: handle errors
            
            guard let document = document else {
                print("Failed to unwrap document")
                return
            }
            
            print(document, documentWasAlreadyOpen)
        }, onCancel: {})
    }
    
    override func openDocument(
        withContentsOf url: URL,
        display displayDocument: Bool,
        completionHandler: @escaping (Document?, Bool, Error?) -> Void
    ) {
        self.updateRecent(url)
        self.documentController.openDocument(withContentsOf: url, display: displayDocument) { document, documentWasAlreadyOpen, error in
            
            if let document {
                self.addDocument(document)
                self.updateRecent(url)
            } else {
                let errorMessage = error?.localizedDescription ?? "unknown error"
                print("Unable to open document '\(url)': \(errorMessage)")
            }

            completionHandler(document, documentWasAlreadyOpen, error)
        }
    }

    override func noteNewRecentDocument(_ document: Document) {
        // The super method is run manually when opening new documents.
    }

    override func removeDocument(_ document: Document) {
        self.documentController.removeDocument(document)

        // TODO: SceneService
//        if self.documentController.documents.isEmpty {
//            switch Settings[\.general].reopenWindowAfterClose {
//            case .showWelcomeWindow:
//                // Opens the welcome window
//                // TODO: Implement opening the welcome window
//                break
//            case .quit:
//                // Quits CodeEdit
//                NSApplication.shared.terminate(nil)
//            case .doNothing:
//                break
//            }
//        }
    }

    override func clearRecentDocuments(_ sender: Any?) {
        self.documentController.clearRecentDocuments(sender)
        UserDefaults.standard.set([], forKey: "recentProjectPaths")
    }
}

// These functions are separated out to make clear these are not part of NSDocumentController
extension NSDocumentProvider {
    func openDocument(onCompletion: @escaping (Document?, Bool) -> Void, onCancel: @escaping () -> Void) {
        let dialog = NSOpenPanel()

        dialog.title = "Open Workspace or File"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = true

        dialog.begin { result in
            if result == .OK, let url = dialog.url {
                self.openDocument(withContentsOf: url, display: true) { document, documentWasAlreadyOpen, error in
                    if let error = error {
                        NSAlert(error: error).runModal()
                        return
                    }

                    guard let document = document else {
                        let alert = NSAlert()
                        alert.messageText = NSLocalizedString(
                            "Failed to get document",
                            comment: "Failed to get document"
                        )
                        alert.runModal()
                        return
                    }
                    onCompletion(document, documentWasAlreadyOpen)
                    print("Document:", document)
                    print("Was already open?", documentWasAlreadyOpen)
                }
            } else if result == .cancel {
                onCancel()
            }
        }
    }

    private func updateRecent(_ url: URL) {
        var recentProjectPaths: [String] = UserDefaults.standard.array(
            forKey: "recentProjectPaths"
        ) as? [String] ?? []
        if let containedIndex = recentProjectPaths.firstIndex(of: url.path) {
            recentProjectPaths.move(fromOffsets: IndexSet(integer: containedIndex), toOffset: 0)
        } else {
            recentProjectPaths.insert(url.path, at: 0)
        }
        UserDefaults.standard.set(recentProjectPaths, forKey: "recentProjectPaths")
    }
}
#endif
