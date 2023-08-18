//
//  StopWatchViewController.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/04.
//

import UIKit

class StopWatchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var miliLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    var array: [String] = []
    var isStart: Bool = false
    var newStart: Bool = false
    var startTime = Date()
    var timer: DispatchSourceTimer? //DispatchSourceTimer을 이용하면 일시정지 하기 쉬움.
    var time: [Double] = [0, 0, 0]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        makeTimer()
        self.tableView?.register(UINib(nibName: "StopWatchTableViewCell", bundle: nil), forCellReuseIdentifier: "StopWatchTableViewCell")
    }
    
    
    func makeTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timer?.schedule(deadline: .now(), repeating: 0.001)
            timer?.setEventHandler(handler: {
                self.timeUp()
            })
        }
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        if isStart == false {
            newStart = false
            startTime = Date()
            timer?.resume()
            isStart = true
            playLabel.text = "중단"
            saveLabel.text = "랩"
        }
        else{
            newStart = true
            timer?.suspend()
            time[0] = Double(minuteLabel.text!)!
            time[1] = Double(secondLabel.text!)!
            time[2] = Double(miliLabel.text!)!
            isStart = false
            saveLabel.text = "재설정"
            playLabel.text = "시작"
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if newStart {
            isStart = false
            saveLabel.text = "랩"
            timer?.resume()
            timer?.suspend()
            time = [0,0,0]
            secondLabel.text = "00"
            minuteLabel.text = "00"
            miliLabel.text = "000"
            array = []
            tableView.reloadData()
        }
        else {
            array.append(minuteLabel.text! + ":" + secondLabel.text! + "." + miliLabel.text!)
            tableView.reloadData()
        }
    }
    
    func timeUp(){
        let timeInterval = Date().timeIntervalSince(startTime)
        var minute = Double((Int)(fmod(timeInterval/60,60))) + time[0]
        var second = Double((Int)(fmod(timeInterval,60))) + time[1]
        var milliSecond = Double((Int)((timeInterval - floor(timeInterval))*1000)) + time[2]
        if minute > 59 {
            minute = minute - 60
        }
        if second > 59 {
            second = second - 60
            minute += 1
        }
        if milliSecond > 999 {
            milliSecond -= 1000
            second += 1
        }
        
        
        miliLabel.text = String(format: "%03.0f", milliSecond)
        secondLabel.text = String(format: "%02.0f", second)
        minuteLabel.text = String(format: "%02.0f", minute)
        
    }
}

extension StopWatchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: "StopWatchTableViewCell", for: indexPath) as? StopWatchTableViewCell)
        else{
            fatalError()
        }
        cell.timeLabel.text = array[indexPath.row]
        cell.labLbel.text = "랩 " + String(indexPath.row+1)
        return cell
    }
    
    
}
