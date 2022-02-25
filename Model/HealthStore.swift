//
//  HealthStore.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import Foundation
import HealthKit


extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

class HealthStore {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    var query2: HKStatisticsCollectionQuery?
    //Working on award
    var query3: HKStatisticsCollectionQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            
        }
    }

    func calculateSteps(completion: @escaping (HKStatisticsCollection?)-> Void) {
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let listStartDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let listPredicate = HKQuery.predicateForSamples(withStart: listStartDate, end: Date(), options: .strictStartDate)
        
        //Working on award
        
        let awardPredicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query3 = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query3!.initialResultsHandler = { query3, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        query2 = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: listPredicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query2!.initialResultsHandler = { query2, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
            
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
        
       
        
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            completion(success)
        }
    
    
    }

}
