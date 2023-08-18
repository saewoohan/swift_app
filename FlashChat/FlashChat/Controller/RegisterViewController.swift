//
//  RegisterViewController.swift
//  FlashChat
//
//  Created by 한승우 on 2022/12/28.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                if let result = authResult {
                    print("your ID was created success")
                    performSegue(withIdentifier: "registerSegue", sender: nil)
                    
                }
                else{
                    print(error!)
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let chatViewController = segue.destination as? ChatViewController else { return }
        
    }
    
}
