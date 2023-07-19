//
//  LiveScheduleView.swift
//  Jaketi
//
//  Created by Ivan on 19/07/23.
//

import SwiftUI

struct LiveScheduleView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ScrollView {
            CurrentStationText()
            
            ScheduleList(trainStation: modelData.trainStations.first!)
        }
    }
}

struct LiveScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        LiveScheduleView()
            .environmentObject(ModelData())
    }
}
