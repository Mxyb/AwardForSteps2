//
//  Home.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import SwiftUI

struct Home: View {
    var animation: Namespace.ID
    
    // Shared Data...
    @EnvironmentObject var sharedData: SharedDataModel
    
    @StateObject var homeData: HomeViewModel = HomeViewModel()
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 15){
                
                // Search Bar...
                
                ZStack{
                    
                    if homeData.searchActivated{
                        SearchBar()
                    }
                    else{
                        SearchBar()
                            .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                    }
                }
                .frame(width: getRect().width / 1.6)
                .padding(.horizontal,25)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut){
                        homeData.searchActivated = true
                    }
                }
                
                Text("Example Text")
                    .font(.custom(customFont, size: 28).bold())
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal,25)
                
                // Awards Tab....
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 18){
                        
                        ForEach(AwardType.allCases,id: \.self){type in
                            
                            // Award Type View...
                            AwardTypeView(type: type)
                        }
                    }
                    .padding(.horizontal,25)
                }
                .padding(.top,28)
                
                // Awards Page...
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 25){
                        
                        ForEach(homeData.filteredAwards){award in
                            
                            // Award Card View...
                            AwardCardView(award: award)
                        }
                    }
                    .padding(.horizontal,25)
                    .padding(.bottom)
                    .padding(.top,80)
                }
                .padding(.top,30)
                
                // See More Button...
                // This button will show all awards on the current award type..
                // since here were showing only 4...
                
                Button {
                    homeData.showMoreAwardsOnType.toggle()
                } label: {
                    
                    // Since we need image ar right...
                    Label {
                        Image(systemName: "arrow.right")
                    } icon: {
                        Text("see more")
                    }
                    .font(.custom(customFont, size: 15).bold())
                    .foregroundColor(Color("Green"))
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
                .padding(.trailing)
                .padding(.top,10)

            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color("HomeBG"))
        // Updating data whenever tab changes...
        .onChange(of: homeData.awardType) { newValue in
            homeData.filterAwardByType()
        }
        // Preview Issue...
        .sheet(isPresented: $homeData.showMoreAwardsOnType) {
            
        } content: {
            MoreAwardsView()
        }
        // Displaying Search View....
        .overlay(
        
            ZStack{
                
                if homeData.searchActivated{
                    SearchView(animation: animation)
                        .environmentObject(homeData)
                }
            }
        )
    }
    
    // Since we're adding matched geometry effect...
    // avoiding code replication...
    @ViewBuilder
    func SearchBar()->some View{
        
        HStack(spacing: 15){
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(.gray)
            
            // Since we need a separate view for search bar....
            TextField("Search", text: .constant(""))
                .disabled(true)
        }
        .padding(.vertical,12)
        .padding(.horizontal)
        .background(
        
            Capsule()
                .strokeBorder(Color.gray,lineWidth: 0.8)
        )
    }
    
    @ViewBuilder
    func AwardCardView(award: Award)->some View{
        
        VStack(spacing: 10){
            
            // Adding Matched Geometry Effect...
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
                        .matchedGeometryEffect(id: "\(award.id)IMAGE", in: animation)
                }
            }
            .frame(width: getRect().width / 2.5, height: getRect().width / 2.5)
        // Moving image to top to look like its fixed at half top...
            .offset(y: -80)
            .padding(.bottom,-80)
            
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
        // Showing Award detail when tapped...
        .onTapGesture {
            
            withAnimation(.easeInOut){
                sharedData.detailAward = award
                sharedData.showDetailAward = true
            }
        }
    }
    
    @ViewBuilder
    func AwardTypeView(type: AwardType)->some View{
        
        Button {
            // Updating Current Type...
            withAnimation{
                homeData.awardType = type
            }
        } label: {
            
            Text(type.rawValue)
                .font(.custom(customFont, size: 15))
                .fontWeight(.semibold)
            // Changing Color based on Current Award Type...
                .foregroundColor(homeData.awardType == type ? Color("Green") : Color.gray)
                .padding(.bottom,10)
            // Adding Indicator at bottom...
                .overlay(
                
                    // Adding Matched Geometry Effect...
                    ZStack{
                        if homeData.awardType == type{
                            Capsule()
                                .fill(Color("Green"))
                                .matchedGeometryEffect(id: "AwardTAB", in: animation)
                                .frame(height: 2)
                        }
                        else{
                            
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .padding(.horizontal,-5)
                    
                    ,alignment: .bottom
                )
        }
    }
}

// Extending View to get Screen Bounds..
extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}


struct Home_Previews: PreviewProvider {
    
    static var previews: some View {
        MainPage()
    }
}
