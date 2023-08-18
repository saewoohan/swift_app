//
//  WorldClockTableViewController.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/04.
//

import UIKit

protocol SendDelegate: AnyObject {
    func send(name: String)
}

class WorldClockTableViewController: UITableViewController, SendDelegate {

    var city: String = ""
    var array: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        array = UserDefaults.standard.array(forKey: "Array") as? [String] ?? []
        self.tableView?.register(UINib(nibName: "WorldClockTableViewCell", bundle: nil), forCellReuseIdentifier: "WorldClockCell")
    }


    @IBAction func addButton(_ sender: UIButton) {
        performSegue(withIdentifier: "segueIdentifier", sender: self)
    }
    
    //편집 화면 만들기
    @IBAction func deleteButton(_ sender: UIButton) {
            
            if self.tableView.isEditing {
                sender.setTitle("편집", for: .normal)
                
                self.tableView.setEditing(false, animated: true)
                
            } else {
                sender.setTitle("완료", for: .normal)
                self.tableView.setEditing(true, animated: true)
                
            }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3){
            self.tableView.reloadData()
        }
    }

    
    // MARK: - protocol을 이용한 B->A 데이터 전달 방식
    
    func send(name: String) {
        array.append(name)
        UserDefaults.standard.set(array, forKey: "Array")
        tableView.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueIdentifier" {
            let nextVC = segue.destination as! WorldAddTableViewController
            //다음 VC의 delegate를 설정해줘야지 가능.
            nextVC.delegate = self
        }
    }
    
}

extension WorldClockTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    //editingStyle에 따른 실행 코드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            array.remove(at: indexPath.row)
            UserDefaults.standard.set(array, forKey: "Array")
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }
    }
    
    //각 index의 editingStyle을 설정.
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Row Editable true
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: "WorldClockCell", for: indexPath) as? WorldClockTableViewCell)
        else{
            fatalError()
        }
        if self.tableView.isEditing {
            cell.timeLabel.isHidden = true
        }
        else {
            cell.timeLabel.isHidden = false
        }
            let seperator = array[indexPath.row].components(separatedBy: ", ")
            let date = DateFormatter()
            date.locale = Locale(identifier: array[indexPath.row])
            date.timeZone = TimeZone(identifier: seperator[0]+"/"+seperator[1])
            date.dateFormat = "HH:mm"
            cell.cityLabel.text = seperator[1]
            cell.timeLabel.text = date.string(from: Date())
        return cell
    }
    
    
    // Move Row Instance Method
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = self.array[sourceIndexPath.row]
        self.array.remove(at: sourceIndexPath.row)
        self.array.insert(moveCell, at: destinationIndexPath.row)
        UserDefaults.standard.set(array, forKey: "Array")
    }
    
}
