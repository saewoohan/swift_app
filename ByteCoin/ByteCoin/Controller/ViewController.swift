//
//  ViewController.swift
//  ByteCoin
//
//  Created by 한승우 on 2022/12/28.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var rateLabel: UILabel!
    let coinManager = CoinManager()
    var rate: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerView.delegate = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //피커 뷰에서 열 1개를 의미하는 컴포넌트를 넘김
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //피커뷰에서 선택할 수 있는 개수
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //피커뷰에 각 코인의 명칭을 넘김
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinLabel.text = coinManager.currencyArray[row]
        fetchData()
    }
    
    func fetchData(){
        let temp = coinManager.baseURL + coinLabel.text! + "?apikey=" + coinManager.apiKey
        if let str = temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: str){
            let alamo = AF.request(url)
            alamo.responseJSON { response in
                switch response.result {
                case .success(let value) :
                    let json = JSON(value)
                    let temp = json["rate"]
                    self.rate = String(format: "%0.2f", temp.floatValue)
                    self.updateUI()
                case .failure:
                    fatalError()
                }
                
            }
        }
    }
    
    func updateUI(){
        rateLabel.text = rate
    }
}

