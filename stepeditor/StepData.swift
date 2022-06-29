//
//  StepData.swift
//  stepeditor
//
//  Created by shinichi teshirogi on 2022/06/24.
//

import Foundation

enum StepDataType: Int {
    case additional = 0
    case speed
    case duration
}

class StepData {
    let stepDistance = 0.5          // 50cm
    var additinalValue: Int = 8000  // 8000step
    var speedValue: Int = 4         // 4km/h
    var durationValue: Int = 60     // 60min
    
    func updateValue(_ stepDataType: StepDataType, value: Int, completion: @escaping (Int?) -> Void) {
        switch stepDataType {
        case .additional:
            additinalValue = value
            let totalDistance = Double(additinalValue) * stepDistance  // m
            let durationInHour = Double(totalDistance) / Double(speedValue)  // m / km/h
            durationValue = Int(durationInHour * 60 / 1000)
            
            completion(value)
        case .speed:
            speedValue = value
            let totalDistance = Double(additinalValue) * stepDistance   // m
            let durationInHour = totalDistance / Double(speedValue)  // m / km/h
            durationValue = Int(durationInHour * 60 / 1000)
            
            completion(value)
        case .duration:
            durationValue = value / 60
            let totalDistance = Double(additinalValue) * stepDistance   // m
            let speed = totalDistance / 1000 / Double(durationValue) * 60   // km / hour
            speedValue = Int(speed)
            
            completion(value)
        }
    }
    
    func valueOf(_ stepDataType: StepDataType) -> Int {
        switch stepDataType {
        case .additional:
            return additinalValue
        case .speed:
            return speedValue
        case .duration:
            return durationValue
        }
    }

    func timeIntervalValue() -> TimeInterval {
        return TimeInterval(durationValue * 60 * -1)
    }
}
