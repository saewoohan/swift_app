//
//  ViewController.swift
//  xylophone
//
//  Created by 한승우 on 2022/12/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Xylophone!"
    }


    @IBAction func buttonPressed(_ sender: UIButton) {
        let soundName = sender.titleLabel!.text!
        playSound(soundName: soundName)
        sender.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            sender.alpha = 1
        }
    }
    
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        
    }
}

