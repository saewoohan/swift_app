//
//  ProfileViewController.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/18.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {
    @IBOutlet weak var editingLabel: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var settingLabel: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var profile: Profile?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = profile?.name
        if let message = profile?.message {
            messageLabel.text = message
        }
        else{
            messageLabel.text = ""
        }
        isSame()
    }
    
    @IBAction func editingButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "editingName", sender: self)
    }
    func isSame() {
        if Auth.auth().currentUser?.email == profile?.email {
            settingLabel.isHidden = false;
            myLabel.text = "나와의 채팅"
            editingLabel.isHidden = true
        }
        else{
            settingLabel.isHidden = true;
            myLabel.text = "1:1 채팅"
            editingLabel.isHidden = false
        }
    }
    
    @IBAction func settingButton(_ sender: UIButton) {

    }
    @IBAction func chatButton(_ sender: UIButton) {
        performSegue(withIdentifier: "chatIdentifier", sender: self)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatIdentifier" {
            guard let chatViewController = segue.destination as? ChatViewController else { return  }
            chatViewController.profile = self.profile
        }

        else {
            guard let editingViewController = segue.destination as? EditingNameViewController else { return }
            editingViewController.profile = self.profile
        }
    }
}
