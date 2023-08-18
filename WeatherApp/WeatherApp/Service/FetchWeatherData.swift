//
//  FetchWeatherData.swift
//  WeatherApp
//
//  Created by yc on 2022/02/18.
//

import UIKit
import Alamofire
import Kingfisher

struct FetchWeatherData {
    private let APIKEY = "72b679ddb227219023234c815867edb3"
    func fetchData(cityName: String, completionHandler: @escaping (Weather?, AFError?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(APIKEY)"
        DispatchQueue.global().async {
            AF
                .request(url)
                .responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            completionHandler(data, nil)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completionHandler(nil, error)
                        }
                        print(error.localizedDescription, "000")
                    }
                }
        }
    }
}
