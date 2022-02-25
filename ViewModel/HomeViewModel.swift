//
//  HomeViewModel.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import SwiftUI

// Using Combine to monitor search field and if user leaves for .5 secs then starts searching...
// to avoid memory issue...
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var awardType: AwardType = .Environmental
    
    // Sample Awards...
    @Published var awards: [Award] = [
    
        Award(type: .Health, title: "10,000 Steps", subtitle: "You reached your step goal", awardImage:"10kSteps"),
        Award(type: .Health, title: "Weekly Target", subtitle: "You reached your weekly goal", awardImage: "7DaySteps"),
        Award(type: .Environmental, title: "Text", subtitle: "Text", awardImage: "TreeBadge"),
        Award(type: .Environmental, title: "Text", subtitle: "Text", awardImage: "RenewEnergy"),
        Award(type: .Social, title: "Text", subtitle: "Text", awardImage: "Smiley"),
        Award(type: .Social, title: "Text", subtitle: "Text", awardImage: "EduBadge"),
    ]

    // Filtered Awards...
    @Published var filteredAwards: [Award] = []
    
    // More Awards on the type...
    @Published var showMoreAwardsOnType: Bool = false
    
    // Search Data...
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    @Published var searchedAwards: [Award]?
    
    var searchCancellable: AnyCancellable?
    
    init(){
        filterAwardByType()
        
        searchCancellable = $searchText.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str != ""{
                    self.filterAwardBySearch()
                }
                else{
                    self.searchedAwards = nil
                }
            })
    }
    
    func filterAwardByType() {
        
        // Filtering Award By Award Type...
        DispatchQueue.global(qos: .userInteractive).async {
            
            let results = self.awards
            // Since it will require more memory so we're using lazy to perform more...
                .lazy
                .filter { award in
                    
                    return award.type == self.awardType
                }
            // Limiting result
                .prefix(4)
            
            DispatchQueue.main.async {
                
                self.filteredAwards = results.compactMap({ award in
                    return award
                })
                
            }
        }
        
    }
    
    func filterAwardBySearch() {
        
        // Filtering Award By Award Type...
        DispatchQueue.global(qos: .userInteractive).async {
            
            let results = self.awards
            // Since it will require more memory so we're using lazy to perform more...
                .lazy
                .filter { award in
                    
                    return award.title.lowercased().contains(self.searchText.lowercased())
                }
            
            DispatchQueue.main.async {
                
                self.searchedAwards = results.compactMap({ award in
                    return award
                })
            }
        }
        
    }
}
