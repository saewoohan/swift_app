//
//  CalculateController.swift
//  BMI-Calculator
//
//  Created by 한승우 on 2022/12/24.
//

import UIKit

class CalculateController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    
    var bmi: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        compare()
    }
    
    
    func compare(){
        scoreLabel.text = String(format: "%0.1f", bmi)
        if bmi < 10 {
            commentLabel.text = "Eat some foods"
            backgroundView.backgroundColor = .red
        }
        else if bmi < 20{
            commentLabel.text = "Good"
            backgroundView.backgroundColor = .none
        }
        else {
            commentLabel.text = "Don't eat food"
            backgroundView.backgroundColor = .red
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
}
