//
//  ContentView.swift
//  Jaketi
//
//  Created by Ivan on 17/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            LiveScheduleView()
                .navigationTitle(Theme.Title.schedule)
                .background(Theme.Colors.greyBg)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Theme.Colors.primary,
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            
    }
}
