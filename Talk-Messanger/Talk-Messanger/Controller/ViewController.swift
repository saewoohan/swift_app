//
//  ViewController.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/16.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var createLabel: UIButton!
    @IBOutlet weak var loginLabel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        warningLabel?.isHidden = true
    }
    
    
    @IBAction func edtingChanged(_ sender: UITextField) {
        if passwordTextfield.text!.count >= 8 && emailTextfield.text!.contains("@"){
            loginLabel.backgroundColor = #colorLiteral(red: 0.9851594567, green: 0.8866841197, blue: 0.009480506182, alpha: 1)
        }
        else{
            loginLabel.backgroundColor = #colorLiteral(red: 0.9638207555, green: 0.9687920213, blue: 0.9643967748, alpha: 1)
        }
        

    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        if loginLabel.backgroundColor == #colorLiteral(red: 0.9638207555, green: 0.9687920213, blue: 0.9643967748, alpha: 1) {
            return
        }
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let result = authResult{
                    print("Login success")
                    self!.performSegue(withIdentifier: "loginIdentifier", sender: self)
                }
                else{
                    self?.warningLabel.isHidden = false
                    self!.emailTextfield.text = ""
                    self!.passwordTextfield.text = ""
                    
                }
            }
        }
    }
    
}

