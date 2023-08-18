//
//  ViewController.swift
//  Quizzer
//
//  Created by 한승우 on 2022/12/23.
//

import UIKit

class ViewController: UIViewController {
    let quiz = [
        Question(q: "A slug's blood is green.", a: "True"),
        Question(q: "Approximately one quarter of human bones are in the feet.", a: "True"),
          Question(q: "The total surface area of two human lungs is approximately 70 square metres.", a: "True"),
          Question(q: "In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.", a: "True"),
          Question(q: "In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.", a: "False"),
          Question(q: "It is illegal to pee in the Ocean in Portugal.", a: "True"),
          Question(q: "You can lead a cow down stairs but not up stairs.", a: "False"),
          Question(q: "Google was originally called 'Backrub'.", a: "True"),
          Question(q: "Buzz Aldrin's mother's maiden name was 'Moon'.", a: "True"),
          Question(q: "The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.", a: "False"),
          Question(q: "No piece of square dry paper can be folded in half more than 7 times.", a: "False"),
          Question(q: "Chocolate affects a dog's heart and nervous system; a few ounces are enough to kill a small dog.", a: "True")]
    @IBOutlet weak var progressBar: UIProgressView!
    var index: Int = 0
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = quiz[index].q
        progressBar.progress = 0
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        let title = sender.titleLabel!.text!
        if quiz[index].a == title {
            sender.backgroundColor = .green
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                sender.backgroundColor = .none
            }
        }
        else{
            sender.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                sender.backgroundColor = .none
            }
        }
        index += 1
        
        if(index == 12){
            index = 0
        }
        label.text = quiz[index].q
        progressBar.progress = Float(index) / Float(12)
        
    }
    
}

