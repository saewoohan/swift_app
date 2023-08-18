//
//  AddChatViewController.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/02/08.
//

import UIKit
import RealmSwift
import FirebaseAuth

class AddChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var people: List<Person>?
    var currentUser: CurrentUser?
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        self.searchBar.searchBarStyle = .minimal
        self.tableView?.register(UINib(nibName: "AddChatTableViewCell", bundle: nil), forCellReuseIdentifier: "AddChatIdentifier")
        loadFriends()
        tableView.layer.borderWidth = CGFloat(0)
    }
    
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    func loadFriends() {
        let user = realm.objects(CurrentUser.self)
        currentUser = user.filter("email == '\((Auth.auth().currentUser?.email)!)'").first
        people = currentUser?.friends
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let chatViewController = segue.destination as? ChatViewController else { return }
        chatViewController.profile = self.profile
    }
}

extension AddChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddChatIdentifier", for: indexPath) as? AddChatTableViewCell else{
            fatalError()
        }
        
        cell.nameLabel.text = people?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let temp = Profile(email: (people?[indexPath.row])!.email, name: (people?[indexPath.row])!.name, message: people?[indexPath.row].message ?? nil, image: people?[indexPath.row].image ?? nil, backgroundImage: people?[indexPath.row].backgroundImage ?? nil)
        self.profile = temp
        performSegue(withIdentifier: "addChat", sender: self)
    }
}



extension AddChatViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadFriends()
        if searchBar.text! == "" {
            tableView.reloadData()
            return
        }
        let answer = people?.filter("name CONTAINS[cd] %@ || email CONTAINS[cd] %@", searchBar.text!, searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        let converted = answer?.reduce(List<Person>()) { (list, element) -> List<Person> in
            list.append(element)
            return list
        }
        people = converted
        tableView.reloadData()
    }
}

