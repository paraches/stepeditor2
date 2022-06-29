//
//  HealthManager.swift
//  stepeditor
//
//  Created by shinichi teshirogi on 2022/06/24.
//

import Foundation
import HealthKit

class HealthManager: NSObject {
    static let sampleType = HKSampleType.quantityType(forIdentifier: .stepCount)!
    static let sampleTypes: Set<HKSampleType> = [
        sampleType
    ]
    static let shared = HealthManager()

    func requestAuth(authCompletion: @escaping (Bool, Error?) -> Void) {
        print("start requestAuth")
        HKHealthStore().requestAuthorization(toShare: HealthManager.sampleTypes,
                                             read: HealthManager.sampleTypes,
                                             completion: { success, error in
            print("finish requestAuth\nstart authCompletion")
            authCompletion(success, error)
            print("finish authCompletion")
        })
    }
    
    func currentStepCount( completion: @escaping (Int?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: HealthManager.sampleType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil)
                return
            }
            let stepCount = Int(sum.doubleValue(for: HKUnit.count()))
            completion(stepCount)
        }
        
        HKHealthStore().execute(query)
    }


    func addSteps(_ stepDataManager: StepData, completion: @escaping (Bool, Error?) -> Void) {
        let now = Date()
        let quantity = HKQuantity(unit: .count(), doubleValue: Double(stepDataManager.additinalValue))
        let objects: HKObject =
        HKQuantitySample(type: HealthManager.sampleType,
                         quantity: quantity,
                         start: now.addingTimeInterval(stepDataManager.timeIntervalValue()),
                         end: now)
        HKHealthStore().save(objects) { success, error in
            completion(success, error)
        }
    }
}
