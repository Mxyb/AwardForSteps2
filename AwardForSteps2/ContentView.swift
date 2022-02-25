//
//  ContentView.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var sharedData = SharedDataModel()
    
    var body: some View {
        VStack {
            
            if sharedData.likedAwards.isEmpty{
                
                Group {
                    MainPage()
                        .environmentObject(sharedData)
                    
                }
            }
            else {
                Image("NoAwards")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .padding(.top,35)
                
                Text("No awards yet")
                    .font(.custom(customFont, size: 25))
                    .fontWeight(.semibold)
            }
        }
    }
}
