//
//  XCUIElement.swift
//  ThemoviedbOneScreenshotTests
//
//  Created by Aleksey Anisov on 02.12.2020.
//  Copyright © 2020 jonfir. All rights reserved.
//

import XCTest

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear text for a non string value")
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
    }
}
