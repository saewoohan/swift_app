//
//  LoginViewController.swift
//  FlashChat
//
//  Created by 한승우 on 2022/12/28.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    //firebase auth사용
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let result = authResult{
                    print("Login success")
                    self!.performSegue(withIdentifier: "loginSegue", sender: nil)
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
