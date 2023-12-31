//
//  ContentView.swift
//  Jaketi
//
//  Created by Ivan on 17/07/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vmDepartureSchedule = DepartureScheduleViewModel()

    var body: some View {
        NavigationStack {
            LiveScheduleView()
                .navigationTitle(Theme.Title.schedule)
                .navigationBarHidden(true)
                .background(Theme.Colors.background)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Theme.Colors.blue,
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            NotificationService.shared.askPermission()
            vmDepartureSchedule.requestAuthorization()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            
    }
}
