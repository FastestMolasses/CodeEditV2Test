//
//  MonospacedFontPicker.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/22/23.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
import CoreText
#endif

import SwiftUI

struct MonospacedFontPicker: View {
    var title: String
    @Binding var selectedFontName: String
    @State private var recentFonts: [String]
    @State private var monospacedFontFamilyNames: [String] = []
    @State private var otherFontFamilyNames: [String] = []

    init(title: String, selectedFontName: Binding<String>) {
        self.title = title
        self._selectedFontName = selectedFontName
        self.recentFonts = UserDefaults.standard.stringArray(forKey: "recentFonts") ?? []
    }

    var body: some View {
        Picker(selection: $selectedFontName, label: Text(title)) {
            Text("System Font")
#if os(macOS)
                .font(Font(NSFont.monospacedSystemFont(ofSize: 13.5, weight: .medium)))
#endif
                .tag("SF Mono")

            if !recentFonts.isEmpty {
                Divider()
                ForEach(recentFonts, id: \.self) { fontFamilyName in
                    Text(fontFamilyName)
                        .font(.custom(fontFamilyName, size: 13.5))
                        .tag(fontFamilyName) // to prevent picker invalid and does not have an associated tag error.
                }
            }

            if !monospacedFontFamilyNames.isEmpty {
                Divider()
                ForEach(monospacedFontFamilyNames, id: \.self) { fontFamilyName in
                    Text(fontFamilyName)
                        .font(.custom(fontFamilyName, size: 13.5))
                        .tag(fontFamilyName)
                }
            }

            if !otherFontFamilyNames.isEmpty {
                Divider()
                Menu {
                    ForEach(otherFontFamilyNames, id: \.self) { fontFamilyName in
                        Button {
                            pushIntoRecentFonts(fontFamilyName)
                            selectedFontName = fontFamilyName
                        } label: {
                            Text(fontFamilyName)
                                .font(.custom(fontFamilyName, size: 13.5))
                        }
                        .tag(fontFamilyName)
                    }
                } label: {
                    Text("Other fonts...")
                }
            }
        }
        .onChange(of: selectedFontName) { _ in
            if selectedFontName != "SF Mono" {
                pushIntoRecentFonts(selectedFontName)

                // remove the font to prevent ForEach conflict
                monospacedFontFamilyNames.removeAll { $0 == selectedFontName }
                otherFontFamilyNames.removeAll { $0 == selectedFontName }
            }
        }
        .task {
            await getFonts()
        }
    }
}

extension MonospacedFontPicker {
    private func pushIntoRecentFonts(_ newItem: String) {
        recentFonts.removeAll(where: { $0 == newItem })
        recentFonts.insert(newItem, at: 0)
        if recentFonts.count > 3 {
            recentFonts.removeLast()
        }
        UserDefaults.standard.set(recentFonts, forKey: "recentFonts")
    }

    private func getFonts() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                let monospacedFontFamilyNames = getMonospacedFamilyNames()
                await MainActor.run {
                    self.monospacedFontFamilyNames = monospacedFontFamilyNames
                }
            }

            group.addTask {
                let otherFontFamilyNames = getOtherFontFamilyNames()
                await MainActor.run {
                    self.otherFontFamilyNames = otherFontFamilyNames
                }
            }
        }
    }

    private func getMonospacedFamilyNames() -> [String] {
#if os(macOS)
        let availableFontFamilies = NSFontManager.shared.availableFontFamilies

        return availableFontFamilies.filter { fontFamilyName in
            // exclude the font if it is in recentFonts to prevent ForEach conflict
            if recentFonts.contains(fontFamilyName) {
               return false
            }

            // exclude default font
            if fontFamilyName == "SF Mono" {
               return false
            }

            // include the font which is fixedPitch
            // include the font which numberOfGlyphs is greater than 26
            if let font = NSFont(name: fontFamilyName, size: 14) {
               return font.isFixedPitch && font.numberOfGlyphs > 26
            } else {
               return false
            }
        }
#elseif os(iOS)
        let availableFontFamilies = UIFont.familyNames
            return availableFontFamilies.filter { fontFamilyName in
                if recentFonts.contains(fontFamilyName) {
                    return false
                }
                if fontFamilyName == "SF Mono" {
                    return false
                }
                if let font = UIFont(name: fontFamilyName, size: 14) {
                    let ctFont = CTFontCreateWithName(fontFamilyName as CFString, 14, nil)
                    let glyphCount = CTFontGetGlyphCount(ctFont)
                    let traits = CTFontGetSymbolicTraits(ctFont)
                    return traits.contains(.traitMonoSpace) && glyphCount > 26
                } else {
                    return false
                }
            }
#endif
   }

   private func getOtherFontFamilyNames() -> [String] {
#if os(macOS)
       let availableFontFamilies = NSFontManager.shared.availableFontFamilies

       return availableFontFamilies.filter { fontFamilyName in
           // exclude the font if it is in recentFonts to prevent ForEach conflict
           if recentFonts.contains(fontFamilyName) {
               return false
           }

           // include the font which is NOT fixedPitch
           // include the font which numberOfGlyphs is greater than 26
           if let font = NSFont(name: fontFamilyName, size: 14) {
               return !font.isFixedPitch && font.numberOfGlyphs > 26
           } else {
               return false
           }
       }
#elseif os(iOS)
       let availableFontFamilies = UIFont.familyNames
           return availableFontFamilies.filter { fontFamilyName in
               if recentFonts.contains(fontFamilyName) {
                   return false
               }
               if let font = UIFont(name: fontFamilyName, size: 14) {
                   let ctFont = CTFontCreateWithName(fontFamilyName as CFString, 14, nil)
                   let glyphCount = CTFontGetGlyphCount(ctFont)
                   let traits = CTFontGetSymbolicTraits(ctFont)
                   return !traits.contains(.traitMonoSpace) && glyphCount > 26
               } else {
                   return false
               }
           }
    #endif
   }
}
