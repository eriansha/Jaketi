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
                .navigationTitle("Live Schedule")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
