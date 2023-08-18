//
//  ViewController.swift
//  EggTimer
//
//  Created by 한승우 on 2022/12/23.
//

import UIKit

class ViewController: UIViewController {
    var timer : Timer?
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    let timerNum = [60, 180, 270]
    var totalNum: Int = 0
    var number: Int = 0
    @IBAction func buttonPressed(_ sender: UIButton) {
        let title = sender.titleLabel!.text!
        label.text = title
        if(title == "Soft") {
            totalNum = timerNum[0]
        }
        else if(title == "Medium"){
            totalNum = timerNum[1]
        }
        else{
            totalNum = timerNum[2]
        }
        number = 0
        startTimer()
    }
    
    func startTimer(){
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        progressBar.progress = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    @objc func timerCallback() {
        progressBar.progress = Float(number) / Float(totalNum)
        number += 1
        if(number == totalNum){
            timer!.invalidate()
            progressBar.progress = 0
            label.text = "Done!"
        }
    }
}

