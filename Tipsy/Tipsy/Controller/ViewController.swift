//
//  ViewController.swift
//  Tipsy
//
//  Created by 한승우 on 2022/12/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelTwenty: UIButton!
    @IBOutlet weak var labelTen: UIButton!
    @IBOutlet weak var labelZero: UIButton!
    @IBOutlet weak var stepperLabel: UIStepper!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var totalBill: UITextField!
    var calcul = Calcul()
    var value: Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func calButtonPressed(_ sender: UIButton) {
        calcul.humans = Int(stepperLabel.value)
        if let bill = self.totalBill.text {
            calcul.totalBill = Float(bill)!
        } else{
            calcul.totalBill = 0
        }
        value = calcul.calculate()
        performSegue(withIdentifier: "SecondController", sender: self)
    }
    @IBAction func tipButton(_ sender: UIButton) {
        if sender.titleLabel!.text == "0%"{
            calcul.tip = 0
            sender.isSelected = true
            labelTen.isSelected = false
            labelTwenty.isSelected = false
        }
        else if sender.titleLabel!.text == "10%" {
            calcul.tip = 0.1
            sender.isSelected = true
            labelZero.isSelected = false
            labelTwenty.isSelected = false
        }
        else {
            calcul.tip = 0.2
            sender.isSelected = true
            labelTen.isSelected = false
            labelZero.isSelected = false
        }
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        splitLabel.text = String(format: "%0.0f", sender.value)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondController = segue.destination as? SecondController else { return }
        
        secondController.total = value
        secondController.tip = Int(calcul.tip * Float(100))
        secondController.people = calcul.humans
    }
}

