//
//  ViewController.swift
//  Weather
//
//  Created by 구희정 on 2022/03/11.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var citynameTextField: UITextField!
    @IBOutlet weak var cityNmaeLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityNmae = self.citynameTextField.text {
            self.getCurrentWeather(cityName: cityNmae)
            self.view.endEditing(true)
        }
    }
    
    //URLSession 을 이용하여 URL 호출을 한다.
    func getCurrentWeather(cityName : String){
        let openWeatherApiKey = "d67b4e7102c92fd3bf124fb2d976ac75"
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(openWeatherApiKey)") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) {
            //컴플리션 핸들러 추가.
            //dataTask 가 API를 호출하고, 서버에서 응답이 오면 컴플리션 핸들러가 호출이 된다.
            //[weak self] 를 사용하여 순환 참조를 해결
            [weak self] data, response, error in
            
            //Server 에서 응답받은 Stats 값을 받아와 처리
            let successRange = (200..<300)
            
            guard let data = data, error == nil else { return }
            //JSONDecoder 은 JSON을 사용자가 정의한 프로토콜로 decoder 해준다.
            let decoder = JSONDecoder()
            
            
            //200번대의 요청 값을 받아 오는지 확인
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                //URLSession 이 호출이 된다 해도 자동으로 메인스레드로 돌아오지 않기때문에 UI작업은 메인스레드로 해야하기 때문에
                //메인스레드로 UI작업을 할 수 있도록 해준다.
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
            }
            else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
    }
    func configureView(weatherInformation : WeatherInformation) {
        self.cityNmaeLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        self.minTempLabel.text = "최저 : \(Int(weatherInformation.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "최고 : \(Int(weatherInformation.temp.maxTemp - 273.15))℃"
    }
    
    //Alert UI 보여지도록 하는 func
    func showAlert(message : String ) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.weatherStackView.isHidden = true
    }
    
}

