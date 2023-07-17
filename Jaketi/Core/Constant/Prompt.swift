//
//  Prompt.swift
//  Jaketi
//
//  Created by Ivan on 17/07/23.
//

import Foundation

/** Struct to collect all hardcoded texts in the project */
struct Prompt { private init() {} }

// MARK: Prompt Base
extension Prompt {
    // TODO: example constant. remove once it's not being used
    static let noHistory = "No History"
}

// MARK: Prompt Title Text
extension Prompt {
    struct Title {
        // TODO: example constant. remove once it's not being used
        static let schedule = "Schedule"
        
        private init() {}
    }
}

// MARK: Prompt Button Text
extension Prompt {
    struct Button {
        // TODO: example constant. remove once it's not being used
        static let select = "Select"
        
        private init() {}
    }
}
