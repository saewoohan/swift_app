//
//  WeatherViewController.swift
//  Clima
//
//  Created by 한승우 on 2022/12/25.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchLabel: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var url = "https://api.openweathermap.org/data/2.5/weather?appid=9b767c727a88939ecc1d415d3064ed25&units=metric&"
    var locationManager = CLLocationManager()
    var weather = Weather()
    var lon: CLLocationDegrees = 0.0
    var lat: CLLocationDegrees = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchLabel.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        fetchData()
        
        
    }
    
    func fetchImage(){
        if weather.id < 300 {
            conditionImageView.image = UIImage(systemName: "cloud.bolt.rain")
        }
        else if weather.id < 400 {
            conditionImageView.image = UIImage(systemName: "cloud.drizzle")
        }
        else if weather.id < 600 {
            conditionImageView.image = UIImage(systemName: "cloud.rain")
        }
        else if weather.id < 700 {
            conditionImageView.image = UIImage(systemName: "cloud.snow")
        }
        else {
            conditionImageView.image = UIImage(systemName: "sun.max")
        }
    }
    
    func fetchData(){
        let temp = url + "q=" + searchLabel.text!
        if let str = temp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let Url = URL(string: str){
            let alamo = AF.request(Url)
            print(Url)
            alamo.responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if(json["message"] == "city not found" || json["message"] == "Nothing to geocode"){
                        print("city not found")
                    }
                    else{
                        self.weather.temp = json["main"]["temp"].doubleValue
                        self.weather.description = json["weather"][0]["description"].stringValue
                        self.weather.id = json["weather"][0]["id"].intValue
                        self.cityLabel.text = self.searchLabel.text!
                        self.temperatureLabel.text = String(format: "%0.0f", self.weather.temp)
                        self.fetchImage()
                    }
                case .failure:
                    fatalError()
                }
            }
        }
    }
    
    func fetchData(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let Url = url + "&lat=\(lat)&lon=\(lon)"
        let alamo = AF.request(Url)
        alamo.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.weather.temp = json["main"]["temp"].doubleValue
                self.weather.description = json["weather"][0]["description"].stringValue
                self.weather.id = json["weather"][0]["id"].intValue
                self.cityLabel.text = json["name"].stringValue
                self.temperatureLabel.text = String(format: "%0.0f", self.weather.temp)
                self.fetchImage()
            case .failure:
                fatalError()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

          if textField == self.searchLabel {
              fetchData()
            
          }

          return true

      }
}


extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        print("버튼 누름")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            fetchData(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

