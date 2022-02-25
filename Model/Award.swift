//
//  Award.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import SwiftUI

// Award Model....

struct Award: Identifiable, Hashable {
    
    var id = UUID().uuidString
    var type: AwardType
    var title: String
    var subtitle: String
    var description: String = ""
    var awardImage: String = ""
    var quantity: Int = 1
    
}

// Award Types....

enum AwardType: String,CaseIterable {
    
    case Environmental = "Environmental"
    case Social = "Social"
    case Health = "Health"
}
