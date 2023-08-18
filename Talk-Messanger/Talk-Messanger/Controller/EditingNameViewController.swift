//
//  EditingNameViewController.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/02/08.
//

import UIKit
import RealmSwift
import FirebaseAuth

class EditingNameViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    let realm = try! Realm()
    var profile: Profile?
    var currentUser: CurrentUser?
    var people: List<Person>?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "친구가 설정한 이름 : \(profile!.name)"
        textField.placeholder = profile!.name
    }
    
    func loadFriends() {
        let user = realm.objects(CurrentUser.self)
        currentUser = user.filter("email == '\((Auth.auth().currentUser?.email)!)'").first
        people = currentUser?.friends
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func endButton(_ sender: UIButton) {
        if textField.text == "" {
            self.dismiss(animated: true)
        }
        else{
            var index = 0
            if let p = people {
                for i in p {
                    if i.email == profile!.email {
                        break;
                    }
                    index += 1
                }
            }
            print(index)
        }
    }
    
}
