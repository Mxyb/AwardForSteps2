//
//  YourAwards.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import SwiftUI

struct YourAwards: View {
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    // Delete Option...
    @State var showDeleteOption: Bool = false
    

    
    var body: some View {
        
        NavigationView {
        
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    HStack {
                        
                        Text("Text Here")
                            .font(.custom(customFont, size: 28))
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.top)
                            .padding(.horizontal,25)
                            
                        
                        Spacer()
                        
                        Button {
                            withAnimation{
                                showDeleteOption.toggle()
                            }
                        } label: {
                            Image("Delete")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 25)
                        }
                        .opacity(sharedData.likedAwards.isEmpty ? 0 : 1)
                        
                        
                    }
                    
                    // Checking if Your Awards is empty
                    if sharedData.likedAwards.isEmpty {
                        
                        Group {
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
                    else {
                        // Displaying Awards...
                        VStack(spacing: 15){
                            
                            // For Designing...
                            ForEach(sharedData.likedAwards){award in
                                
                                HStack(spacing: 0){
                                    
                                    if showDeleteOption {
                                        
                                        Button {
                                            deleteAward(award: award)
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.red)
                                        }
                                        .padding(.trailing)
                                    }
                                    
                                    CardView(award: award)
                                    
                                   
                                }
                            }
                        }
                        .padding(.top,25)
                        .padding(.horizontal)
                    }
                    
                
        
        
      
    }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
            
                Color("HomeBG")
                    .ignoresSafeArea()
            )
            }
}

    @ViewBuilder
    func CardView(award: Award) -> some View {
        
        HStack(spacing: 15) {
            
            Image(award.awardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(award.title)
                    .font(.custom(customFont, size: 18))
                    .lineLimit(1)
                
                Text(award.subtitle)
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Green"))
                
                Text("Type: \(award.type.rawValue)")
                    .font(.custom(customFont, size: 13))
                    .foregroundColor(.gray)
    
            }
            
        }
        .padding(.horizontal,10)
        .padding(.vertical,10)
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(
        
            Color.white
                .cornerRadius(10)
        )
        
    }
    
    func deleteAward(award: Award) {
        
        if let index = sharedData.likedAwards.firstIndex(where: { currentAward in
            return award.id == currentAward.id
        }){
            
            let _ = withAnimation {
                // removing...
                sharedData.likedAwards.remove(at: index)
            }
        }
    }
}

struct YourAwards_Previews: PreviewProvider {
    static var previews: some View {
        YourAwards()
    }
}
