//
//  ChatViewController.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/18.
//

import UIKit
import Firebase
import FirebaseAuth
import RealmSwift

class ChatViewController: UIViewController {
    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var profile: Profile?
    var message: [Message] = []
    var finder: [Message] = []
    let realm = try! Realm()
    
    @IBOutlet weak var finderTextField: UITextField!
    @IBOutlet weak var magniBar: UINavigationBar!
    @IBOutlet weak var naviBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadMessages()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        tableView.separatorStyle = .none
        naviBar.isHidden = false
        magniBar.isHidden = true
        naviItem.title = profile?.name
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    

    @IBAction func editingFinder(_ sender: UITextField) {
        finder = []
        for i in message {
            if let text = finderTextField.text {
                if i.body.contains(text){
                    finder.append(i)
                }
            }
        }
        DispatchQueue.main.async {
            if self.finder.isEmpty {
                return
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func magCancel(_ sender: UIBarButtonItem) {
        magniBar.isHidden = true
        naviBar.isHidden = false
        finder = []
        loadMessages()
    }
    
    @IBAction func magnifyingButton(_ sender: UIBarButtonItem) {
        magniBar.isHidden = false
        naviBar.isHidden = true
    }
    
    func returnCheck(collection: String) -> Bool {
        let loadchat = realm.objects(Chat.self).filter("collection == '\(collection)'").first
        if loadchat == nil {
            return true
        }
        else {
            return false
        }
    }
    func retriveName() -> String{
        let email = (Auth.auth().currentUser?.email)!
        let loadName = realm.objects(CurrentUser.self).filter("email == '\(email)'").first
        return (loadName?.name)!
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        var collection = profile!.email+(Auth.auth().currentUser?.email!)!
        collection = String(collection.sorted(by: <))

        if let messageBody = textField.text, let messageSender = Auth.auth().currentUser?.email {
            var chat = Chat()
            chat.collection = collection
            chat.image = profile?.image
            chat.message = messageBody
            chat.receiver = (profile?.name)!
            chat.senderEmail = messageSender
            chat.sender = retriveName()
            chat.date = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
            chat.receiveEmail = (profile?.email)!

            if returnCheck(collection: collection){
                do {
                    try self.realm.write {
                        self.realm.add(chat)
                    }
                } catch {
                    fatalError()
                }
            }
            else{
                do {
                    try self.realm.write {
                        let user = realm.objects(Chat.self).filter("collection == '\(collection)'").first
                        self.realm.delete(user!)
                        self.realm.add(chat)
                    }
                }
                catch{
                    fatalError()
                }
            }
            
            db.collection(collection).addDocument(data: [
                "sender": messageSender,
                "receiver": profile?.email,
                "body": messageBody,
                "date": Date().timeIntervalSince1970
            ]) {(error) in
                if let e = error {
                    print(e)
                }
                else {
                    DispatchQueue.main.async {
                        self.textField.text = ""
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    
    func loadMessages() {
        var collection = profile!.email+(Auth.auth().currentUser?.email!)!
        collection = String(collection.sorted(by: <))
        db.collection(collection).order(by: "date").addSnapshotListener { (QuerySnapshot, error) in
            self.message = []

            if let e = error {
                print(e)
            }
            else {
                if let snapshotDocuments = QuerySnapshot?.documents {
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

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if finder.isEmpty {
            return message.count
        }
        else {
            return finder.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mss: Message
        if finder.isEmpty {
            mss = message[indexPath.row]
        }
        else {
            mss = finder[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.bodyLabel.text = mss.body
        
        if mss.sender == Auth.auth().currentUser?.email {
            cell.imageViewLabel.isHidden = true
            cell.myImageView.isHidden = false
            cell.nameLabel.textAlignment = .right
            cell.nameLabel.text = "나"
        }
        else {
            cell.imageViewLabel.isHidden = false
            cell.myImageView.isHidden = true
            cell.nameLabel.textAlignment = .left
            cell.nameLabel.text = profile?.name
        }

        // Configure the cell...

        return cell
    }


}
