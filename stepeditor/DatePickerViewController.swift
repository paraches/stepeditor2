//
//  DatePickerViewController.swift
//  stepeditor
//
//  Created by shinichi teshirogi on 2022/06/25.
//

import Foundation
import UIKit

class DatePickerViewController: BasePickerViewController, UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var datePickerView: UIDatePicker!
    
    override func viewDidLoad() {
        self.presentationController?.delegate = self

        guard let stepDataType = stepDataType, let stepData = stepData else {
            return
        }

        let oldValue = stepData.valueOf(stepDataType)
        datePickerView.countDownDuration = TimeInterval(oldValue * 60)
    }
    
    // MARK: UIAdaptivePresentationControllerDelegate
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.viewDidDismiss(stepDataType: stepDataType!, value: Int(datePickerView.countDownDuration))
    }
}
