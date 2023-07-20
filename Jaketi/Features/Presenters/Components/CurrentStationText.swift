//
//  CurrentStationText.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct CurrentStationText: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Kamu berada di stasiun")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("Dukuh Atas BNI")
                    .font(.title3)
                    .fontWeight(.regular)
            }
            
            Spacer()
        }.padding(.horizontal)
    }
}

struct CurrentStationText_Previews: PreviewProvider {
    static var previews: some View {
        CurrentStationText()
    }
}
