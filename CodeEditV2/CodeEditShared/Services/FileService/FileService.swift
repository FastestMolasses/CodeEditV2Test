//
//  FileServiced.swift
//  CodeEditV2
//
//  Created by Abe Malla on 4/30/24.
//

import Foundation

protocol FileProvider {
    func fileExists(atPath path: URL) -> Bool
    func createDirectory(atPath path: URL) throws
    func readData(from path: URL) -> Data?
    func writeData(_ data: Data, to path: URL) throws

    static func applicationSupportDirectory() -> URL
}

final class FileService {
    static func applicationSupportDirectory() -> URL {
#if os(macOS)
        // TODO: THIS ENDS UP IN THE CONTAINER FOLDER
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent("CodeEdit", isDirectory: true)
#elseif os(iOS)
        // TODO: THIS IS NOT THE APPLICATION SUPPORT DIRECTORY
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
#else
        fatalError("Unsupported platform")
#endif
    }
}
