//
//  AlarmTableViewController.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/04.
//

import UIKit
protocol Alarm: AnyObject {
    func send(label: String, h: String, m: String, isON: Bool, text: String)
    func delete()
    func toggle(dayLabel: String, timeLabel: String, isON: Bool)
}

class AlarmTableViewController: UITableViewController {
    var arr: [String] = []
    //넘기는 요일
    var label: [String] = []
    //넘기는 텍스트
    var text: [String] = []
    var isON: [Bool] = []
    var change: Bool = false
    var index: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView?.register(UINib(nibName: "AlarmTableViewCell", bundle: nil), forCellReuseIdentifier: "AlarmCell")
        arr = UserDefaults.standard.array(forKey: "arr") as? [String] ?? []
        label = UserDefaults.standard.array(forKey: "label") as? [String] ?? []
        isON = UserDefaults.standard.array(forKey: "isON") as? [Bool] ?? []
        //1초마다 #selector 함수를 실행시키게 함
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime()
    {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeCurrent = formatter.string(from: date as Date)
        formatter.dateFormat = "E"
        let day = formatter.string(from: date as Date)
        if arr.count != 0 {
            for t in 0...arr.count-1 {
                if arr[t] == timeCurrent && (label[t].contains(day)) && isON[t] == true {
                    //play Sound
                }
            }
        }
    }
    

    @IBAction func editButton(_ sender: UIButton) {
        if self.tableView.isEditing {
            sender.setTitle("편집", for: .normal)
            self.tableView.setEditing(false, animated: true)
        } else {
            sender.setTitle("완료", for: .normal)
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        change = false
        self.performSegue(withIdentifier: "AlarmAdd", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlarmAdd" {
            let nextVC = segue.destination as! AlarmAddViewController
            //다음 VC의 delegate를 설정해줘야지 가능.
            nextVC.delegate = self
            nextVC.change = self.change
        }
    }
    
    func saveArr(){
        UserDefaults.standard.set(arr, forKey: "arr")
        UserDefaults.standard.set(self.label, forKey: "label")
        UserDefaults.standard.set(isON, forKey: "isON")
    }
    
}

extension AlarmTableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? AlarmTableViewCell)
        else{
            fatalError()
        }
        cell.delegate = self
        cell.timeLabel.text = arr[indexPath.row]
        cell.dayLabel.text = label[indexPath.row]
        cell.toggleSwitch.isOn = isON[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.change = true
        index = indexPath.row
        //애니매이션 사라지게 하기
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3){
            tableView.deselectRow(at: indexPath, animated: true)
        }
        performSegue(withIdentifier: "AlarmAdd", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            arr.remove(at: indexPath.row)
            label.remove(at: indexPath.row)
            isON.remove(at: indexPath.row)
            saveArr()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension AlarmTableViewController: Alarm {
    
    func send(label: String, h: String, m: String, isON: Bool, text: String) {
        if change == false{
            if text == "" {
                if label != "" && label != "안 함 >" {
                    self.label.append("알람, " + label)
                }
                else {
                    self.label.append("알람")
                }
            }
            else{
                if label != "" && label != "안 함 >" {
                    self.label.append(text + ", " + label)
                }
                else{
                    self.label.append(text)
                }
            }
            self.arr.append(h + ":" + m)
            self.isON.append(true)
        }
        else {
            if text == "" {
                if label != "" && label != "안 함 >" {
                    self.label[index] = "알람, " + label
                }
                else {
                    self.label[index] = "알람"
                }
            }
            else{
                if label != "" && label != "안 함 >" {
                    self.label[index] = text + ", " + label
                }
                else{
                    self.label[index] = text
                }
            }
            self.arr[index] = h + ":" + m
        }
        
        saveArr()
        tableView.reloadData()
    }
    
    func delete(){
        arr.remove(at: index)
        label.remove(at: index)
        isON.remove(at: index)
        saveArr()
        tableView.reloadData()
    }
    
    func toggle(dayLabel: String, timeLabel: String, isON: Bool){
        for t in 0...arr.count-1 {
            if arr[t] == timeLabel && dayLabel == label[t] {
                self.isON[t] = isON
            }
        }
        
        saveArr()
    }
}
