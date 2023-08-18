//
//  MessageViewController.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/17.


import UIKit
import RealmSwift
import FirebaseAuth

class MessageViewController: UIViewController {
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var chat: Results<Chat>?
    let realm = try! Realm()
    let currentEmail = (Auth.auth().currentUser?.email)!
    var profile: Profile?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChat()
        tableView.dataSource = self
        tableView.delegate = self
        self.searchBar.searchBarStyle = .minimal
        self.tableView?.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatIdentifier")
        secondView.isHidden = true
        searchBar.layer.borderWidth = 0
        topView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadChat()
        tableView.reloadData()
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        secondView.isHidden = true
        topView.isHidden = false
    }
    @IBAction func searchButton(_ sender: UIButton) {
        secondView.isHidden = false
        topView.isHidden = true
        loadChat()
        tableView.reloadData()
    }
    
    @IBAction func addChat(_ sender: UIButton) {
        
    }
    
    func loadChat() {
        let loadchat = realm.objects(Chat.self).filter("receiveEmail == '\(currentEmail)' OR senderEmail == '\(currentEmail)'").sorted(byKeyPath: "date", ascending: false)
        self.chat = loadchat
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let chatViewController = segue.destination as? ChatViewController else { return }
        chatViewController.profile = self.profile
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chat?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatIdentifier", for: indexPath) as? ChatTableViewCell else{
            fatalError()
        }
        if chat?[indexPath.row].senderEmail == currentEmail {
            cell.nameLabel.text = chat?[indexPath.row].receiver ?? nil
            cell.chatText.text = chat?[indexPath.row].message ?? nil
        }
        else {
            cell.nameLabel.text = chat?[indexPath.row].sender ?? nil
            cell.chatText.text = chat?[indexPath.row].message ?? nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chat?[indexPath.row].senderEmail == currentEmail {
            let temp = Profile(email: (chat?[indexPath.row].receiveEmail)!, name: (chat?[indexPath.row].receiver)!, message: nil, image: (chat?[indexPath.row].image) ?? nil, backgroundImage: (chat?[indexPath.row].image) ?? nil)
            self.profile = temp
        }
        else {
            let temp = Profile(email: (chat?[indexPath.row].senderEmail)!, name: (chat?[indexPath.row].sender)!, message: nil, image: (chat?[indexPath.row].image) ?? nil, backgroundImage: (chat?[indexPath.row].image) ?? nil)
            self.profile = temp
        }
        performSegue(withIdentifier: "chatSegue", sender: self)
    }
    
}

extension MessageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadChat()
        if searchBar.text! == "" {
            tableView.reloadData()
            return
        }
        chat = chat?.filter("sender CONTAINS[cd] %@ || receiver CONTAINS[cd] %@", searchBar.text!, searchBar.text!)
        tableView.reloadData()
    }
}
