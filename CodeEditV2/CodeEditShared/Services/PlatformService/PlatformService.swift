//
//  PlatformService.swift
//  CodeEditV2
//
//  Created by Abe Malla on 4/26/24.
//

import Foundation
#if os(macOS)
import AppKit
#endif

enum PlatformService {
    static var appVersion: String {
        Bundle.appVersion ?? ""
    }

    static var appBuild: String {
        Bundle.buildString ?? ""
    }

    static var appVersionPostfix: String {
        Bundle.versionPostfix ?? ""
    }

    /// Return the Xcode version and build (if installed)
    static var xcodeVersion: String? {
#if os(macOS)
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.dt.Xcode"),
              let bundle = Bundle(url: url),
              let infoDict = bundle.infoDictionary,
              let version = infoDict["CFBundleShortVersionString"] as? String,
              let buildURL = URL(string: "\(url)Contents/version.plist"),
              let buildDict = try? NSDictionary(contentsOf: buildURL, error: ()),
              let build = buildDict["ProductBuildVersion"]
        else {
            return nil
        }
        
        return "\(version) (\(build))"
#else
        return nil
#endif
    }

    /// Get program and operating system information and copy it to clipboard
    static func copyInformation() {
        var copyString = "CodeEdit: \(appVersion)\(appVersionPostfix) (\(appBuild))\n"
        copyString.append("\(Bundle.systemName): \(Bundle.systemVersionBuild)")
        
        if let xcodeVersion {
            copyString.append("\nXcode: \(xcodeVersion)")
        }
        
        @Service var pasteboardService: PasteboardService
        pasteboardService.clear()
        pasteboardService.copy(copyString)
    }
}
