//
//  BasePickerViewController.swift
//  stepeditor
//
//  Created by shinichi teshirogi on 2022/06/27.
//

import Foundation
import UIKit

class BasePickerViewController: UIViewController {
    var delegate: SheetDismissProtocol?
    var stepDataType: StepDataType?
    var stepData: StepData?
}
