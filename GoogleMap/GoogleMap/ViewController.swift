//
//  ViewController.swift
//  GoogleMap
//
//  Created by 한승우 on 2023/02/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    private var mapView: GMSMapView!
    private var placesClient: GMSPlacesClient!
    var locationManager:CLLocationManager!
    var lan: CLLocationDegrees?
    var lon: CLLocationDegrees?
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var googleMap: GMSMapView?
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButton()
        createMap()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        placesClient = GMSPlacesClient.shared()
        requestJSON(placeID: "없음")
    }
    
    func createMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 37.566535, longitude: 126.9779692, zoom: 14)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.isMyLocationEnabled = true
        mapView?.delegate = self
        googleMap = mapView
    }
    
    func makeButton(){
        buttonOutlet.layer.cornerRadius = 25
        buttonOutlet.layer.shadowColor = UIColor.gray.cgColor
        buttonOutlet.layer.shadowOpacity = 1.0
        buttonOutlet.layer.shadowOffset = CGSize(width: 3, height: 3)
        buttonOutlet.layer.shadowRadius = 6
    }
    
    func resetMap(lan: CLLocationDegrees, lon: CLLocationDegrees) {
        let camera = GMSCameraPosition.camera(withLatitude: 37.566535, longitude: 100, zoom: 14)
        googleMap?.moveCamera(GMSCameraUpdate.setCamera(camera))
        print(googleMap?.camera.target)
    }
    
    
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))
        placesClient?.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: { [self]
          (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }

          if let placeLikelihoodList = placeLikelihoodList {
            for likelihood in placeLikelihoodList {
              let place = likelihood.place
                self.requestJSON(placeID: place.placeID!)
                self.resetMap(lan: self.lan!, lon: self.lon!)
            }
          }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.last {
          mapView?.animate(toLocation: location.coordinate)
       }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
       locationManager.startUpdatingLocation()
    }
    
    func requestJSON(placeID: String){
        let url = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCHyUj34OHf_erQ0Tuft33UdXsy-k7Wz7E&place_id=ChIJzzlcLQGifDURm_JbQKHsEX4"
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            
            /** 서버로부터 받은 데이터 활용 */
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                self.lon = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                self.lan = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                break
                /** 정상적으로 reponse를 받은 경우 */
            case .failure(let error):
                /** 그렇지 않은 경우 */
                break
            }
        }
        
    }
    
}

