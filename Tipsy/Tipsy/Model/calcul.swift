//
//  calcul.swift
//  Tipsy
//
//  Created by 한승우 on 2022/12/25.
//

import Foundation

struct Calcul {
    
    var totalValue: Float = 0.0
    var humans: Int = 0
    var totalBill: Float = 0.0
    var tip: Float = 0.0
    mutating func calculate() -> Float{
        let value = totalBill * Float(1+tip)
        self.totalValue = value / Float(humans)
        return self.totalValue
    }
    
}
