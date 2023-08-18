//
//  WorldAddTableViewController.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/04.
//

import UIKit

class WorldAddTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    //매우 중요한 protocol 사용법.
    weak var delegate: SendDelegate?
    var array: [String] = []
    var city: String = ""
    var filteredArr: [String] = []
    var isFiltering: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        for timeZone in TimeZone.knownTimeZoneIdentifiers {
            let str = timeZone.replacingOccurrences(of: "/", with: ", ")

            array.append(str)
        }
        

        searchBar.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let charactor = Array(Set(self.array.map{ $0.first! })).sorted()[section]
        
        if self.searchBar.text?.isEmpty == true {
            return self.array.filter { $0.first! == charactor }.count
        }
        
        return self.array.filter { $0.first! == charactor }.filter { $0.contains(self.searchBar.text!)}.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let charactor = Array(Set(self.array.map { $0.first! })).sorted()[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if self.searchBar.text?.isEmpty == true {
            cell.textLabel!.text = self.array.filter { $0.first! == charactor }[indexPath.row]
        }
        else{
            cell.textLabel!.text = self.array.filter { $0.first! == charactor }.filter { $0.contains(self.searchBar.text!) }[indexPath.row]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.send(name: array[indexPath.row])
        self.dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 각 Section의 이름은 item의 첫 글자로 설정
        return String(Array(Set(array.map { $0.first! })).sorted()[section])
    }
    // MARK: - Navigation

}

extension WorldAddTableViewController: UISearchBarDelegate {
    
    //키보드가 내려가게 하기.
    private func dissmissKeyboard() {
            searchBar.resignFirstResponder()
    }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }

}
