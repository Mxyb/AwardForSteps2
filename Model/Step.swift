//
//  Step.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}
