//
//  MoreAwardsView.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import SwiftUI

struct MoreAwardsView: View {
    var body: some View {
        
        VStack{
            Text("More Awards")
                .font(.custom(customFont, size: 24).bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
        .background(Color("HomeBG").ignoresSafeArea())
    }
}

struct MoreAwardsView_Previews: PreviewProvider {
    static var previews: some View {
        MoreAwardsView()
    }
}
