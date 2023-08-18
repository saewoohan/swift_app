//
//  Calculator.swift
//  Calculator
//
//  Created by 한승우 on 2023/01/03.
//

import Foundation

class Calculator {
    let firstNumber: Double
    let secondNumber: Double
    let oper: String
    
    init(firstNumber: Double, secondNumber: Double, oper: String) {
        self.firstNumber = firstNumber
        self.secondNumber = secondNumber
        self.oper = oper
    }
    
    func operation() -> String {
        if self.oper == "÷" {
            return String(firstNumber / secondNumber)
        }
        else if self.oper == "×" {
            return String(firstNumber * secondNumber)
        }
        else if self.oper == "-" {
            return String(firstNumber - secondNumber)
        }
        else if self.oper == "+" {
            return String(firstNumber + secondNumber)
        }
        return "0"
    }
}
