//
//  AlarmAddViewController.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/08.
//

import UIKit

protocol Send: AnyObject {
    func send(array: [Int])
    func swit(isON: Bool)
    func textChange(text: String)
}

class AlarmAddViewController: UIViewController {

    
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    weak var delegate: Alarm?
    let dayArray = ["일", "월", "화", "수", "목", "금", "토"]
    
    //넘기는 요일
    var label: String = "안 함 >"
    var day: [Int] = []
    var hour: [String] = []
    var minute: [String] = []
    
    //넘기는 시간
    var h: String = "00"
    var m: String = "00"
    
    //넘기는 스위치
    var isON: Bool = true
    
    //넘기는 텍스트
    var text: String = ""
    
    //편집 인지 아닌지
    var change: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.dataSource = self
        pickerView.delegate = self
        tableView.layer.cornerRadius = 10
        for temp in 0...23 {
            hour.append(String(format: "%02.0f", Float(temp)))
        }
        for temp in 0...59 {
            minute.append(String(format: "%02.0f", Float(temp)))
        }
        label = "안 함 >"
        if change == true {
            self.navigationBar.topItem?.title = "알람 편집"
            self.buttonLabel.isHidden = false
        }
        else{
            self.navigationBar.topItem?.title = "알람 추가"
            self.buttonLabel.isHidden = true
        }
        self.tableView?.register(UINib(nibName: "AlarmAddTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        print(text)
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        delegate?.delete()
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        delegate?.send(label: label, h: h, m: m, isON: isON, text: text)
        self.dismiss(animated: true)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "identifier" {
            let nextVC = segue.destination as! AddDayViewController
            //다음 VC의 delegate를 설정해줘야지 가능.
            nextVC.delegate = self
        }
    }
    
}

extension AlarmAddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hour.count
        }
        else{
            return minute.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return hour[row]
        }
        else{
            return minute[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            h = hour[row]
        }
        else{
            m = minute[row]
        }
    }
    
}

extension AlarmAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? AlarmAddTableViewCell else {
            fatalError()
        }
        cell.delegate = self
        if indexPath.row == 0 {
            cell.switchLabel.isHidden = true
            cell.textField.isHidden = true
            cell.firstLabel.isHidden = false
            cell.label.text = "반복"
            if label == "" {
                cell.firstLabel.text = "안 함 >"
            }
            else {
                cell.firstLabel.text = label
            }

        }
        else if indexPath.row == 1{
            cell.switchLabel.isHidden = true
            cell.textField.isHidden = false
            cell.firstLabel.isHidden = true
            cell.label.text = "레이블"
            cell.textField.placeholder = "알람"
            cell.textField.text = text
        }
        else{
            cell.switchLabel.isHidden = false
            cell.textField.isHidden = true
            cell.firstLabel.isHidden = true
            cell.label.text = "다시 알림"
        }
    
        // Configure the cell...

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "identifier", sender: self)
        }
    }
    
}

extension AlarmAddViewController: Send {
    
    func swit(isON: Bool) {
        self.isON = isON
    }
    
    func send(array: [Int]) {
        day = array
        var temp: String = ""
        for t in 0...6 {
            if day[t] == 1 {
                temp.append(dayArray[t] + " ")
            }
        }
        
        label = temp
        tableView.reloadData()
        
    }
    
    func textChange(text: String) {
        self.text = text
        UserDefaults.standard.set(text, forKey: "String")
    }
    
}
