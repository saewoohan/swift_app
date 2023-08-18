//
//  ViewController.swift
//  BMI-Calculator
//
//  Created by 한승우 on 2022/12/24.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!

    var bmi: Float = 0.0
    var weight: Float = 75
    var height: Float = 1.5
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func calculatePressed(_ sender: UIButton) {
        bmi = weight / (height * height)
        performSegue(withIdentifier: "calculate", sender: self)

    }
    
    @IBAction func weightSlider(_ sender: UISlider) {
        weight = sender.value
        let str = String(format: "%0.0f", weight)
        weightLabel.text = str + "Kg"
    }
    
    @IBAction func heightSlider(_ sender: UISlider) {
        height = sender.value
        let str = String(format: "%0.2f", height)
        heightLabel.text = str + "m"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let calculateController = segue.destination as? CalculateController else { return }
        
        calculateController.bmi = self.bmi
       
    }
}

