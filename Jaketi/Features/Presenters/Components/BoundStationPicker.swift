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
        Picker("Select Destination", selection: $selectedDestination) {
            ForEach(DestinationType.allCases, id: \.self) { destination in
                Text(destination.getLabel())
                
            }
        }
        .pickerStyle(.segmented)
    }
}

struct BoundStationPicker_Previews: PreviewProvider {
    static var previews: some View {
        BoundStationPicker(selectedDestination: .constant(.bundaranHI))
    }
}
