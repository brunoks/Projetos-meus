//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Bruno Vieira on 27/10/17.
//  Copyright © 2017 Bruno Vieira. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    var middleOperation = ""
    var dontStop = ""
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    var currentOperation = Operation.Empty

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer (contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        outputLbl.text = "0"
    }
    
    @IBAction func clearLbl(sender: UIButton) {
        playSound()
        processOperation(operation: Operation.Empty)
        outputLbl.text = "0"
        middleOperation = ""
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        runningNumber += "\(sender.tag)"
        
        outputLbl.text = "\(middleOperation) \(runningNumber)"
        
        middleOperation += "\(sender.tag)"
    }
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
        middleOperation += " ÷"
        outputLbl.text = "\(middleOperation)"
    }
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
        middleOperation += " x"
        outputLbl.text = "\(middleOperation)"
        
    }
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
        middleOperation += " -"
        outputLbl.text = "\(middleOperation)"
    }
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
        middleOperation += " +"
        outputLbl.text = "\(middleOperation)"
    }
    @IBAction func onEqualsPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
        middleOperation = ""
    }
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            // A user selected an operator, but then selected another operator without
            //first entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                leftValStr = result
                outputLbl.text = result
            }
            currentOperation = operation
        } else {
//         This is a first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }

}

