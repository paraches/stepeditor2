//
//  ViewController.swift
//  stepeditor
//
//  Created by shinichi teshirogi on 2022/06/24.
//

import UIKit

class ViewController: UIViewController, SheetDismissProtocol {
    let stepData = StepData()
    
    @IBOutlet weak var currentStepValue: UILabel!
    @IBOutlet weak var additionalStepValue: UILabel!
    @IBOutlet weak var speedValue: UILabel!
    @IBOutlet weak var durationValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        HealthManager.shared.requestAuth(authCompletion: { result, error in
            if result {
                self.updateCurrentStepCount()
            }
            else {
                print("Auth error: \(error!)")
            }
        })
        self.updateViewFace()
    }
    
    @IBAction func clickAdditionalStepButton(_ sender: Any) {
        self.showSheet(.additional)
    }
    
    @IBAction func clickSpeedButton(_ sender: Any) {
        self.showSheet(.speed)
    }
    
    @IBAction func clickDurationButton(_ sender: Any) {
        self.showSheet(.duration)
    }
    
    @IBAction func clickAddButton(_ sender: Any) {
        HealthManager.shared.addSteps(stepData, completion: {success, error in
            if success {
                self.showDialog("書き込み完了", message: "歩数を書き込みました。")
                self.updateCurrentStepCount()
            }
            else {
                self.showDialog("Error", message: "\(error!.localizedDescription)")
            }
        })
    }
    
    private func showDialog(_ title: String, message: String) {
        DispatchQueue.main.async {
            let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(dialog, animated: true)
        }
    }
    
    private func updateViewFace() {
        self.additionalStepValue.text = String(stepData.additinalValue)
        self.speedValue.text = String(stepData.speedValue)
        self.durationValue.text = String(stepData.durationValue)
    }
    
    private func updateCurrentStepCount() {
        HealthManager.shared.currentStepCount(completion: { stepCount in
            if let stepCount = stepCount {
                DispatchQueue.main.async {
                    self.currentStepValue.text = String(stepCount)
                }
            }
        })
    }
    
    private func showSheet(_ stepDataType: StepDataType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: BasePickerViewController
        switch stepDataType {
        case .additional, .speed:
            vc = storyboard.instantiateViewController(withIdentifier: "IntPickerViewController") as! IntPickerViewController
        case .duration:
            vc = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        }
        
        vc.stepDataType = stepDataType
        vc.delegate = self
        vc.stepData = stepData
        
        self.present(vc, animated: true)
    }
    
    // MARK: SheetDismissProtocol
    
    func viewDidDismiss(stepDataType: StepDataType, value: Int) {
        switch stepDataType {
        case .additional:
            print("additional: \(value)")
        case .speed:
            print("speed: \(value)")
        case .duration:
            print("duration: \(value)")
        }
        stepData.updateValue(stepDataType, value: value, completion: { v in
            DispatchQueue.main.async {
                self.updateViewFace()
            }
        })
    }
}

