//
//  TimerViewController.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/04.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    var hour: [String] = []
    var minute: [String] = []
    var second: [String] = []
    
    //아래의 코드를 구조체 혹은 배열로 만들면 더 짧은 코드가 가능, 하지만 첫 클론앱이라 가독성을 높이기 위해 따로 떼서 사용함.
    var h: Int = 0
    var min: Int = 0
    var sec: Int = 0
    
    var timer: DispatchSourceTimer?
    
    var timeLeft = 0
    
    var isStart = false
    var stop = false

    override func viewDidLoad() {
        super.viewDidLoad()
        for temp in 0...23 {
            hour.append(String(temp))
        }
        for temp in 0...59 {
            minute.append(String(temp))
            second.append(String(temp))
        }
        makeTimer()
        startLabel.text = "시작"
    }
    
    
    func makeTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timer?.schedule(deadline: .now(), repeating: 1.0)
            timer?.setEventHandler(handler: {
                self.timerMethod()
            })
        }
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        if stop == true {
            timer?.resume()
            timer?.suspend()
            stop = false
        }
        else{
            timer?.suspend()
        }
        
        timeLeft = 0
        pickerView.isHidden = false
        timeLabel.isHidden = true
        startLabel.text = "시작"
        isStart = false
        h = 0
        min = 0
        sec = 0
    }
    
    
    @IBAction func startButton(_ sender: UIButton) {
        //시작
        if isStart == false {

            if stop == true {
                stop = false
            }
            else{
                calcul()
                stop = false
            }

            if timeLeft != 0 {
                timer?.resume()
                pickerView.isHidden = true
                timeLabel.isHidden = false
                startLabel.text = "일시정지"
                isStart = true
            }
            
        }
        //일시 정지
        else{
            stop = true
            isStart = false
            timer?.suspend()
            startLabel.text = "시작"
        }
    }
    
    @objc func timerMethod() {
        var temp = timeLeft
        
        var temp_h = 0
        var temp_m = 0
        var temp_s = 0
        
        while temp >= 3600 {
            temp -= 3600
            temp_h += 1
        }
        while temp >= 60 {
            temp -= 60
            temp_m += 1
        }
        temp_s = temp
        timeLabel.text = String(format: "%02.0f", Double(temp_h)) + ":" + String(format: "%02.0f", Double(temp_m)) + "." + String(format: "%02.0f", Double(temp_s))
        
        timeLeft -= 1
        if timeLeft <= 0 {
            timeLeft = 0
            h = 0
            sec = 0
            min = 0
            isStart = false
            stop = false
            pickerView.isHidden = false
            timeLabel.isHidden = true
            startLabel.text = "시작"
            timer?.suspend()
            TimerViewController.sound()
        }
    }
    
    func calcul() {
        timeLeft += sec
        timeLeft += min * 60
        timeLeft += h * 3600
        print(timeLeft)
    }
    
}


extension TimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hour.count
        }
        else if component == 1{
            return minute.count
        }
        else {
            return second.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return hour[row] + "시간"
        }
        else if component == 1{
            return minute[row] + "분"
        }
        else {
            return second[row] + "초"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            h = Int(hour[row])!
        }
        else if component == 1{
            min = Int(minute[row])!
        }
        else {
            sec = Int(minute[row])!
        }
    }
}

extension TimerViewController{
    // [설명 : 디바이스 사운드 재생 메소드 : 무음 모드일 경우도 소리 재생됨]
    // [필요 import : import AVFoundation]
    // [사용 방법 : UIDevice.sound()]
    static func sound() {
        //AudioServicesPlaySystemSound(SystemSoundID(1003)) // SMSReceived [ReceivedMessage.caf]
        //AudioServicesPlaySystemSound(SystemSoundID(1004)) // SMSReceived [SentMessage.caf]
        //AudioServicesPlaySystemSound(SystemSoundID(1016)) // SMSSent [tweet_sent.caf]
        AudioServicesPlaySystemSound(SystemSoundID(1307)) // SMSReceived_Selection [sms-received1.caf]
    }
}
