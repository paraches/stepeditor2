//
//  IntPickerViewController.swift
//  stepeditor
//
//  Created by shinichi teshirogi on 2022/06/25.
//

import Foundation
import UIKit

class IntPickerViewController: BasePickerViewController, UIAdaptivePresentationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    let pickDataDic: [StepDataType: [String]] = [
        .additional: ["1000", "2000", "3000", "4000", "5000", "8000", "10000", "12000"],
        .speed: ["1", "2", "3", "4", "5", "6", "8", "10"]]

    @IBOutlet weak var pickerView: UIPickerView!

    override func viewDidLoad() {
        self.presentationController?.delegate = self
        
        guard let stepDataType = stepDataType, let stepData = stepData, let dataArray = pickDataDic[stepDataType] else {
            return
        }

        let oldValue = stepData.valueOf(stepDataType)
        if let row = dataArray.firstIndex(of: String(oldValue)) {
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
        }
    }

    
    // MARK: UIAdaptivePresentationControllerDelegate
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        guard let stepDataType = stepDataType, let dataArray = pickDataDic[stepDataType] else {
            return
        }

        let title = dataArray[pickerView.selectedRow(inComponent: 0)]
        delegate?.viewDidDismiss(stepDataType: stepDataType, value: Int(title)!)
    }
    
    
    // MARK: UIPickerViewDataSource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let stepDataType = stepDataType else { return 0 }

        let count = pickDataDic[stepDataType]?.count
        return count ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let stepDataType = stepDataType else { return nil }

        if let dataArray = pickDataDic[stepDataType] {
            return dataArray[row]
        }
        
        return nil
    }
}
