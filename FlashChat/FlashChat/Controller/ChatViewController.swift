//
//  ChatViewController.swift
//  FlashChat
//
//  Created by 한승우 on 2022/12/28.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    var message: [Message] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = "FlashChat!"
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: "MessagaeCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadMessages()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("message").addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "date": Date().timeIntervalSince1970
            ]) {(error) in
                if let e = error {
                    print(e)
                }
                else{
                    DispatchQueue.main.async{
                        self.messageTextfield.text = ""
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
    //firebase db사용
    func loadMessages() {
        db.collection("message").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.message = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.message.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.message.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mss = message[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessagaeCell
        cell.label.text = mss.body
        
        if mss.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: "BrandLightPurple")
            cell.label.textColor = UIColor(named: "BrandPurple")
        }
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: "BrandPurple")
            cell.label.textColor = UIColor(named: "BrandLightPurple")
        }
        return cell
    }
    
    
}
