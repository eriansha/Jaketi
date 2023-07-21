//
//  ContentView.swift
//  Jaketi
//
//  Created by Ivan on 17/07/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = NotificationViewModel()
    var body: some View {
        NavigationStack {
            LiveScheduleView()
                .navigationTitle("Live Schedule")
        }
        .onAppear {
            viewModel.requestPermissionNotifications()
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
