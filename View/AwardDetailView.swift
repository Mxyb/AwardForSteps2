//
//  AwardDetailView.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import SwiftUI

struct AwardDetailView: View {
    var award: Award
    
    // For Matched Geometry Effect...
    var animation: Namespace.ID
    
    // Shared Data Model...
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var homeData: HomeViewModel
    
    var body: some View {
        
        VStack{
            
            // Title Bar and Award Image...
            VStack{
                
                // Title Bar...
                HStack{
                    
                    Button {
                        // Closing View...
                        withAnimation(.easeInOut){
                            sharedData.showDetailAward = false
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button {
                        addToLiked()
                    } label: {
                        Image("Liked")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(isLiked() ? .red : Color.black.opacity(0.7))
                    }


                }
                .padding()
                
                // Award Image...
                // Adding Matched Geometry Effect...
                Image(award.awardImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .matchedGeometryEffect(id: "\(award.id)\(sharedData.fromSearchPage ? "SEARCH" : "IMAGE")", in: animation)
                    .padding(.horizontal)
                    .offset(y: -12)
                    .frame(maxHeight: .infinity)
            }
            .frame(height: getRect().height / 2.7)
            .zIndex(1)
            
            // Award Details...
            ScrollView(.vertical, showsIndicators: false) {
                
                // Award Data...
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text(award.title)
                        .font(.custom(customFont, size: 20).bold())
                    
                    Text(award.subtitle)
                        .font(.custom(customFont, size: 18))
                        .foregroundColor(.gray)
                    
                    Text("Insert Text Here")
                        .font(.custom(customFont, size: 16).bold())
                        .padding(.top)
                    
                    Text("Insert More Text Here")
                        .font(.custom(customFont, size: 15))
                        .foregroundColor(.gray)
                    
                    Button {
                        
                    } label: {
                        
                        // Since we need image at right...
                        Label {
                            Image(systemName: "arrow.right")
                        } icon: {
                            Text("Full description")
                        }
                        .font(.custom(customFont, size: 15).bold())
                        .foregroundColor(Color("Green"))
                    }

                }
                .padding([.horizontal,.bottom],20)
                .padding(.top,25)
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(
                Color.white
                // Corner Radius for only top side....
                    .clipShape(CustomCorners(corners: [.topLeft,.topRight], radius: 25))
                    .ignoresSafeArea()
            )
            .zIndex(0)
        }
        .background(Color("HomeBG").ignoresSafeArea())
    }
    
    func isLiked()->Bool{
        
        return sharedData.likedAwards.contains { award in
            return self.award.id == award.id
        }
    }
    
    
    func addToLiked(){
        
        if let index = sharedData.likedAwards.firstIndex(where: { award in
            return self.award.id == award.id
        }){
            // Remove from liked....
            sharedData.likedAwards.remove(at: index)
        }
        else{
            // add to liked
            sharedData.likedAwards.append(award)
        }
    }
    
    
    func isEarned() {
        
        
        
        
        
    }
}

struct AwardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample Award for Building Preview....
//        AwardDetailView(award: HomeViewModel().awards[0])
//            .environmentObject(SharedDataModel())
        
        MainPage()
    }
}
