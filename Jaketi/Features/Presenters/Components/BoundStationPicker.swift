//
//  BoundStationPicker.swift
//  Jaketi
//
//  Created by Hilmy Noerfatih on 21/07/23.
//

import SwiftUI

struct BoundStationPicker: View {
    @Binding var selectedDestination: DestinationType
    
    var body: some View {
        Form {
            Section (header: Spacer(minLength: 0)) {
                Picker("Bound for", selection: $selectedDestination) {
                    ForEach(DestinationType.allCases, id: \.self) { destination in
                        Text(destination.getLabel())
                    }
                }
                .pickerStyle(.menu)
                .tint(Theme.Colors.highlightedLabel)
            }
        }
//        .scrollContentBackground(.hidden)
        .foregroundColor(.gray)
        .frame(height: 80)
        .padding(.top, -15)
        .padding(.horizontal, -5)
    }
}

struct BoundStationPicker_Previews: PreviewProvider {
    static var previews: some View {
        BoundStationPicker(selectedDestination: .constant(.bundaranHI))
    }
}
