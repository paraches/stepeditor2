//
//  SheetDismissProtocol.swift
//  stepeditor
//
//  Created by shinichi teshirogi on 2022/06/25.
//

import Foundation

protocol SheetDismissProtocol {
    func viewDidDismiss(stepDataType: StepDataType, value: Int)
}
