//
//  ViewController.swift
//  roll-dice
//
//  Created by 한승우 on 2022/12/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var secondDice: UIImageView!
    @IBOutlet weak var firstDice: UIImageView!
    
    let dice = [#imageLiteral(resourceName: "DiceOne"),  #imageLiteral(resourceName: "DiceTwo"),  #imageLiteral(resourceName: "DiceThree"),  #imageLiteral(resourceName: "DiceFour"),  #imageLiteral(resourceName: "DiceFive"),  #imageLiteral(resourceName: "DiceSix")]
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        let randomIntf = Int.random(in: 0...5)
        let randomInts = Int.random(in: 0...5)
        
        
        secondDice.image = dice[randomIntf]
        firstDice.image = dice[randomInts]
    }
}

