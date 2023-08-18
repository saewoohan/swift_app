//
//  FriendViewController.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/17.
//

import UIKit
import RealmSwift
import FirebaseAuth

class FriendViewController: UIViewController {
    @IBOutlet weak var magView: UIView!
    @IBOutlet weak var label: UILabel!
    let realm = try! Realm()
    @IBOutlet weak var rightButton: UIButton!
    var people: List<Person>?
    var profile: Profile?
    var currentUser: CurrentUser?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriends()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView?.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.searchBar.searchBarStyle = .minimal
        magView.isHidden = true
        rightButton.setImage(UIImage(named: "gearshape.fill"), for: .normal)
    }
    
    func loadFriends() {
        let user = realm.objects(CurrentUser.self)
        currentUser = user.filter("email == '\((Auth.auth().currentUser?.email)!)'").first
        people = currentUser?.friends
    }
    
    func copyFriend(friend: CurrentUser)->Person{
        let person = Person()
        person.email = friend.email
        person.name = friend.name
        person.image = friend.image
        person.message = friend.message
        
        return person
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        magView.isHidden = true
        label.isHidden = false
        rightButton.setImage(UIImage(named: "gearshape.fill"), for: .normal)
        loadFriends()
        tableView.reloadData()
    }
    
    @IBAction func magiButton(_ sender: UIButton) {
        magView.isHidden = false
        rightButton.setImage(UIImage(named: "magnifyingglass"), for: .normal)
        label.isHidden = true
    }
    
    @IBAction func plusFriends(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "친구를 추가합니다.", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "이메일을 입력해 주세요.", style: .default) { (action) in
            let user = self.realm.objects(CurrentUser.self)
            if let friend = user.filter("email == '\(textField.text!)'").first {
                let person = self.copyFriend(friend: friend)
                do {
                    try self.realm.write {
                        let contains = {
                            if person.email == self.currentUser?.email {
                                return true
                            }
                            if let friend = self.currentUser?.friends {
                                for i in friend {
                                    if i.email == person.email {
                                        return true
                                    }
                                }
                            }
                            return false
                        }
                        if contains() {
                            let alert = UIAlertController(title: "경고", message: "이미 친구인 사용자입니다.", preferredStyle: .alert) // 이 메세지 부분에 내가 원하는 문구를 넣으면 된다.
                            self.present(alert, animated: true, completion: nil) // 만약 이 코드를 실행시키는 곳이 ViewController가 아니라면 임의로 뷰 컨트롤러를 설정해서 present하자.
                            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} ) // TimeInterval 값을 조정해서 얼마나 떠 있게 할 지 조정하면 된다.
                        }
                        else {
                            self.currentUser?.friends.append(person)
                            self.tableView.reloadData()
                        }
                    }
                    
                }
                catch {

                }
            } else{
                let alert = UIAlertController(title: "경고", message: "존재하지 않는 사용자입니다.", preferredStyle: .alert) // 이 메세지 부분에 내가 원하는 문구를 넣으면 된다.
                self.present(alert, animated: true, completion: nil) // 만약 이 코드를 실행시키는 곳이 ViewController가 아니라면 임의로 뷰 컨트롤러를 설정해서 present하자.
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} ) // TimeInterval 값을 조정해서 얼마나 떠 있게 할 지 조정하면 된다.
            }

        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "email"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileViewController = segue.destination as? ProfileViewController else { return }
        profileViewController.profile = self.profile
    }
}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (people?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell else{
            fatalError()
        }
        if indexPath.row == 0{
            cell.nameLabel.text = "나"
            cell.messageLabel.text = currentUser?.message
            if let t = currentUser?.image {
                cell.imageViewLabel.image = UIImage(data: t)
            }
            return cell
        }
        
        cell.nameLabel.text = (people?[indexPath.row-1].name)!
        cell.messageLabel.text = (people?[indexPath.row-1].message) ?? ""
        if let t = people?[indexPath.row-1].image {
            cell.imageViewLabel.image = UIImage(data: t)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let temp = Profile(email: (currentUser?.email)!, name: (currentUser?.name)!, message: currentUser?.message ?? nil, image: currentUser?.image ?? nil, backgroundImage: currentUser?.backgroundImage ?? nil)
            self.profile = temp
            self.performSegue(withIdentifier: "profileIdentifier", sender: self)
        }
        else{
            let temp = Profile(email: (people?[indexPath.row-1])!.email, name: (people?[indexPath.row-1])!.name, message: people?[indexPath.row-1].message ?? nil, image: people?[indexPath.row-1].image ?? nil, backgroundImage: people?[indexPath.row-1].backgroundImage ?? nil)
            self.profile = temp
            self.performSegue(withIdentifier: "profileIdentifier", sender: self)
        }
       
    }
    
    
}


extension FriendViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadFriends()
        if searchBar.text! == "" {
            tableView.reloadData()
            return
        }
        let answer = people?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        let converted = answer?.reduce(List<Person>()) { (list, element) -> List<Person> in
            list.append(element)
            return list
        }
        people = converted
        tableView.reloadData()
    }
    
}
