//
//  LoginViewController.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/17.
//

import UIKit
import FirebaseAuth
import RealmSwift

class LoginViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var secondPassword: UITextField!
    @IBOutlet weak var firsePassword: UITextField!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        errorLabel?.isHidden = true
        errorLabel?.text = "다시 입력해주세요."
    }
    

    @IBAction func editingText(_ sender: UITextField) {
        if firsePassword.text!.count >= 8 && emailTextField.text!.contains("@") && secondPassword.text!.count >= 8{
            buttonLabel.backgroundColor = #colorLiteral(red: 0.9851594567, green: 0.8866841197, blue: 0.009480506182, alpha: 1)
        }
        else{
            buttonLabel.backgroundColor = #colorLiteral(red: 0.9638207555, green: 0.9687920213, blue: 0.9643967748, alpha: 1)
        }
    }
    func initial() {
        nameTextField.text = ""
        emailTextField.text = ""
        firsePassword.text = ""
        secondPassword.text = ""
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        if buttonLabel.backgroundColor == #colorLiteral(red: 0.9638207555, green: 0.9687920213, blue: 0.9643967748, alpha: 1) {
            return
        }
        if firsePassword.text != secondPassword.text {
            errorLabel?.text = "다시 입력해주세요."
            errorLabel.isHidden = false
            return
        }
        if nameTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel?.text = "이름을 입력해 주세요."
            return
        }
        if let email = emailTextField.text, let password = firsePassword.text {
            Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                if let result = authResult {
                    let currentUser = CurrentUser()
                    currentUser.email = email
                    currentUser.name = nameTextField.text!
                    try! realm.write {
                        realm.add(currentUser)
                    }
                    print("your ID was created success")
                    initial()
                }
                else{
                    errorLabel.text = "이미 회원가입 된 사용자입니다."
                    initial()
                    self.errorLabel.isHidden = false
                }
            }
            
        }
    }
    
    
    
}
