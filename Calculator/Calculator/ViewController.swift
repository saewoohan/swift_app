//
//  ViewController.swift
//  Calculator
//
//  Created by 한승우 on 2023/01/03.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ACLabel: UIButton!
    @IBOutlet weak var label: UILabel!
    var firstNumber: String = ""
    var secondNumber: String = ""
    var oper: String = ""
    var isFirst: Bool = true
    var isPoint: Bool = false
    var result: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func numButton(_ sender: UIButton) {
        if result != "" {
            result = ""
            isFirst = true
            firstNumber = ""
        }
        if isFirst {
            if sender.currentTitle == "."{
                if !isPoint {
                    firstNumber += sender.currentTitle!
                    label.text = firstNumber
                    isPoint = true
                }
            }
            else{
                firstNumber += sender.currentTitle!
                label.text = firstNumber
            }
        }
        else{
            if sender.currentTitle == "."{
                if !isPoint {
                    secondNumber += sender.currentTitle!
                    label.text = secondNumber
                    isPoint = true
                }
            }
            else{
                secondNumber += sender.currentTitle!
                label.text = secondNumber
            }
        }
        if firstNumber != "" || secondNumber != "" {
            ACLabel.setTitle("C", for: .normal)
        }
    }
    
    
    
    @IBAction func calButton(_ sender: UIButton) {
        let title = sender.currentTitle!
        if result != "" {
            firstNumber = result
        }
        isFirst = false
        oper = title
    }
    
    @IBAction func funcButton(_ sender: UIButton) {
        let title = sender.currentTitle!
        print("first Number : \(firstNumber)")
        print("second Number : \(secondNumber)")
        print("oper : \(oper)")
        if title == "%" {
            if isFirst || result != ""{
                if var first = Double(firstNumber) {
                    first /= Double(100)
                    firstNumber = String(first)
                    label.text = firstNumber
                }
            }
            else {
                if var second = Double(secondNumber) {
                    second /= Double(100)
                    secondNumber = String(second)
                    label.text = secondNumber
                }
            }
        }
        
        else if title == "+/-" {
            if isFirst || result != ""{
                if var first = Double(firstNumber) {
                    first = -first
                    firstNumber = String(first)
                    label.text = firstNumber
                }
            }
            else {
                if var second = Double(secondNumber) {
                    second = -second
                    secondNumber = String(second)
                    label.text = secondNumber
                }
            }
        }
        
        else if title == "AC" {
            firstNumber = ""
            secondNumber = ""
            oper = ""
            label.text = "0"
        }
        
        
        else if title == "C" {
            if isFirst || result != "" {
                firstNumber = ""
                label.text = "0"
                ACLabel.setTitle("AC", for: .normal)
            }
            else{
                secondNumber = ""
                label.text = "0"
                ACLabel.setTitle("AC", for: .normal)
            }
        }
        
        
    }
    
    
    @IBAction func calcul(_ sender: UIButton) {
        
        if firstNumber != "" && secondNumber != "" {
            if let first = Double(firstNumber), let second = Double(secondNumber) {
                let calculator = Calculator(firstNumber: first , secondNumber: second, oper: oper)
                label.text = calculator.operation()
                isFirst = false
                firstNumber = label.text!
                secondNumber = ""
                oper = ""
                result = label.text!
            }
        }
    }
    
}

