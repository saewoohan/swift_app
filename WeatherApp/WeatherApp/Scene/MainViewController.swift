//
//  MainViewController.swift
//  WeatherApp
//
//  Created by yc on 2022/02/18.
//

import UIKit
import SnapKit
import Kingfisher

class MainViewController: UIViewController {
    
    let fetchWeatherData = FetchWeatherData()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tap)
        
        return scrollView
    }()
    @objc func didTapScrollView() {
        textField.resignFirstResponder()
    }
    private let contentView = UIView()
    private let bottomView = UIView()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "지역(도시)명을 입력하세요."
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 4.0
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.font = .systemFont(ofSize: 16.0, weight: .regular)
        textField.returnKeyType = .search
        textField.delegate = self
        
        return textField
    }()
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 48.0, weight: .medium)
        
        return label
    }()
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 42.0, weight: .semibold)
        label.textColor = .systemGreen
        
        return label
    }()
    private lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20.0, weight: .regular)
        
        return label
    }()
    private lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20.0, weight: .regular)
        
        return label
    }()
    private lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20.0, weight: .regular)
        
        return label
    }()
    private lazy var mainDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 24.0, weight: .regular)
        
        return label
    }()
    private lazy var subDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
        
        setupKeyboardNotification()
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboard = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboard.cgRectValue.height
            self.bottomView.snp.removeConstraints()
            self.bottomView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(16.0)
                $0.top.equalTo(minTemperatureLabel.snp.bottom).offset(16.0)
                $0.height.equalTo(keyboardHeight)
                $0.bottom.equalToSuperview().inset(16.0)
            }
        }
    }
    @objc func keyboardWillHide(_ noti: NSNotification) {
        self.bottomView.snp.removeConstraints()
        self.bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(minTemperatureLabel.snp.bottom).offset(16.0)
            $0.height.equalTo(10.0)
            $0.bottom.equalToSuperview().inset(16.0)
            
        }
        
    }
}
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            var text = textField.text
            text?.removeAll(where: { $0 == " " })
            fetchData(text ?? "")
        }
        textField.resignFirstResponder()
        return true
    }
}

private extension MainViewController {
    func fetchData(_ cityName: String) {
        fetchWeatherData.fetchData(cityName: cityName) { [weak self] weather, error in
            guard let self = self else { return }
            
            guard let weather = weather else {
                if error != nil {
                    self.alertError()
                }
                return
            }
            
            self.iconImageView.kf.setImage(with: weather.weatherInfo[0].iconURL)
            self.cityNameLabel.text = weather.name
            self.mainDescriptionLabel.text = weather.weatherInfo[0].main
            self.subDescriptionLabel.text = weather.weatherInfo[0].desc
            self.temperatureLabel.text = self.kelvinToCelsius(kValue: weather.tempInfo.temp) + "℃"
            self.feelsLikeLabel.text = "체감온도:  " + self.kelvinToCelsius(kValue: weather.tempInfo.feelsLike) + "℃"
            self.maxTemperatureLabel.text = "최고기온:  " + self.kelvinToCelsius(kValue: weather.tempInfo.tempMax) + "℃"
            self.minTemperatureLabel.text = "최저기온:  " + self.kelvinToCelsius(kValue: weather.tempInfo.tempMin) + "℃"
        }
    }
    func kelvinToCelsius(kValue: Float) -> String {
        let celsius = kValue - 273.15
        return String(format: "%.0f", celsius)
    }
    func alertError() {
        let alertController = UIAlertController(title: "Error", message: "City not found", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) {
            _ in
            self.textField.text = ""
            self.textField.becomeFirstResponder()
        })
        present(alertController, animated: true, completion: nil)
    }
    
    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        let commonInset = 16.0
        [
            textField,
            iconImageView,
            cityNameLabel,
            mainDescriptionLabel,
            subDescriptionLabel,
            temperatureLabel,
            feelsLikeLabel,
            maxTemperatureLabel,
            minTemperatureLabel,
            bottomView
        ].forEach { contentView.addSubview($0) }
        
        textField.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(commonInset)
            $0.height.equalTo(48.0)
        }
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(100.0)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textField.snp.bottom).offset(commonInset)
        }
        cityNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(commonInset)
            $0.top.equalTo(iconImageView.snp.bottom).offset(commonInset)
        }
        mainDescriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(cityNameLabel.snp.bottom).offset(commonInset)
        }
        subDescriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(mainDescriptionLabel.snp.bottom).offset(commonInset / 2)
        }
        temperatureLabel.snp.makeConstraints {
            $0.leading.equalTo(cityNameLabel.snp.trailing).offset(commonInset)
            $0.bottom.equalTo(cityNameLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(commonInset)
        }
        feelsLikeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(subDescriptionLabel.snp.bottom).offset(commonInset)
        }
        maxTemperatureLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(feelsLikeLabel.snp.bottom).offset(commonInset / 2)
        }
        minTemperatureLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(maxTemperatureLabel.snp.bottom).offset(commonInset / 2)
        }
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(minTemperatureLabel.snp.bottom).offset(commonInset)
            $0.height.equalTo(10.0)
            $0.bottom.equalToSuperview().inset(commonInset)
        }
    }
}
