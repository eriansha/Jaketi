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
    
    /** threshold time in second to refetch */
    private var thresholdRefetch: Double = 60
    
    // Function to start the timer
    private func refreshData() {
        // Create a timer that repeats every 60 seconds (adjust as needed)
        Timer.scheduledTimer(withTimeInterval: thresholdRefetch, repeats: true) { _ in
            // reassign model data
            let newModelData = ModelData()
            modelData.trainStations = newModelData.trainStations
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
