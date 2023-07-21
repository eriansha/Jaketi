//
//  JaketiApp.swift
//  Jaketi
//
//  Created by Ivan on 17/07/23.
//

import SwiftUI

@main
struct JaketiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
