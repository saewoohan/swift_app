//
//  SecondController.swift
//  Tipsy
//
//  Created by 한승우 on 2022/12/25.
//

import UIKit

class SecondController: UIViewController {

    
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    var total: Float = 0.0
    var people: Int = 0
    var tip: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    func updateUI(){
        let str = String(format: "%0.2f", total)
        totalLabel.text = str
        explainLabel.text = "Split between \(people) people, with \(tip)% tip."
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
