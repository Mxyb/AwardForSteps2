//
//  SearchView.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import SwiftUI

struct SearchView: View {
    var animation: Namespace.ID
    
    // Shared Data...
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var homeData: HomeViewModel
    
    // Activating Text Field with the help of FocusState...
    @FocusState var startTF: Bool
    
    var body: some View {
        
        VStack(spacing: 0){
            
            // Search Bar...
            HStack(spacing: 20){
                
                // Close Button...
                Button {
                    withAnimation{
                        homeData.searchActivated = false
                    }
                    homeData.searchText = ""
                    // Resetting...
                    sharedData.fromSearchPage = false
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(Color.black.opacity(0.7))
                }

                // Search Bar...
                HStack(spacing: 15){
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    // Since we need a separate view for search bar....
                    TextField("Search", text: $homeData.searchText)
                        .focused($startTF)
                        .textCase(.lowercase)
                        .disableAutocorrection(true)
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(
                
                    Capsule()
                        .strokeBorder(Color("Green"),lineWidth: 1.5)
                )
                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                .padding(.trailing,20)
            }
            .padding([.horizontal])
            .padding(.top)
            .padding(.bottom,10)
            
            // Showing Progress if searching...
            // else showing no results found if empty...
            if let awards = homeData.searchedAwards{
                
                if awards.isEmpty{
                    
                    // No Results Found....
                    VStack(spacing: 10){
                        
                        Image("NotFound")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top,60)
                        
                        Text(" Not Found")
                            .font(.custom(customFont,size: 22).bold())
                        
                        Text("Try a more generic search term or try looking for alternative awards.")
                            .font(.custom(customFont,size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,30)
                    }
                    .padding()
                }
                else{
                    // Filter Results....
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 0){
                            
                            // Found Text...
                            Text("Found \(awards.count) results")
                                .font(.custom(customFont, size: 24).bold())
                                .padding(.vertical)
                            
                            // Staggered Grid...
                            // See my Staggered Video..
                            // Link in Bio...
                            StaggeredGrid(columns: 2,spacing: 20, list: awards) {award in
                                
                                // Card View....
                                AwardCardView(award: award)
                            }
                        }
                        .padding()
                    }
                }
            }
            else{
                
                ProgressView()
                    .padding(.top,30)
                    .opacity(homeData.searchText == "" ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .background(
        
            Color("HomeBG")
                .ignoresSafeArea()
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startTF = true
            }
        }
    }
    
    @ViewBuilder
    func AwardCardView(award: Award)->some View{
        
        VStack(spacing: 10){
            
            ZStack{
                
                if sharedData.showDetailAward{
                    Image(award.awardImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0)
                }
                else{
                    Image(award.awardImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: "\(award.id)SEARCH", in: animation)
                }
            }
            // Moving image to top to look like its fixed at half top...
            .offset(y: -50)
            .padding(.bottom,-50)
            
            Text(award.title)
                .font(.custom(customFont, size: 18))
                .fontWeight(.semibold)
                .padding(.top)
            
            Text(award.subtitle)
                .font(.custom(customFont, size: 14))
                .foregroundColor(.gray)
            
        }
        .padding(.horizontal,20)
        .padding(.bottom,22)
        .background(
        
            Color.white
                .cornerRadius(25)
        )
        .padding(.top,50)
        .onTapGesture {
            
            withAnimation(.easeInOut){
                sharedData.fromSearchPage = true
                sharedData.detailAward = award
                sharedData.showDetailAward = true
            }
        }
    }
}





struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
