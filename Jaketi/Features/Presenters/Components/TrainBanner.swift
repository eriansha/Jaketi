//
//  NearestTrain.swift
//  Jaketi
//
//  Created by Hilmy Noerfatih on 21/07/23.
//

import SwiftUI

struct TrainBanner: View {
    var body: some View {
        VStack {
            ZStack{
//                GeometryReader { geometry in
                    Image("Banner")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: geometry.size.width)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
//            }
            Spacer()
        }
    }
}

struct Train_Previews: PreviewProvider {
    static var previews: some View {
        NearestTrainBanner()
    }
}
