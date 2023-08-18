//
//  AddDayViewController.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/09.
//

import UIKit

class AddDayViewController: UIViewController {
    weak var delegate: Send?
    @IBOutlet weak var tableView: UITableView!
   
    var array = [["일",0], ["월",0], ["화",0], ["수",0], ["목",0], ["금",0], ["토",0]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        self.tableView?.register(UINib(nibName: "AddDayTableViewCell", bundle: nil), forCellReuseIdentifier: "AddDayTableViewCell")
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        var temp: [Int] = []
        for t in 0...6 {
            temp.append(array[t][1] as! Int)
        }
        delegate?.send(array: temp)
        self.dismiss(animated: true)
        
    }
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        let temp: [Int] = [0,0,0,0,0,0,0]
        delegate?.send(array: temp)
        self.dismiss(animated: true)
    }
}


extension AddDayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddDayTableViewCell", for: indexPath) as? AddDayTableViewCell else {
            fatalError()
        }
        cell.label.text = array[indexPath.row][0] as! String + "요일마다"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                array[indexPath.row][1] = 0
                cell.accessoryType = .none
            }
            else {
                array[indexPath.row][1] = 1
                cell.accessoryType = .checkmark
            }
        }
    }
    
}
