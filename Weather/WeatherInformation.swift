//
//  WeatherInformation.swift
//  Weather
//
//  Created by 구희정 on 2022/03/11.
//

import Foundation

//Codable 이란 ?
//자신을 변환하거나 외부 표현으로 변환하는 타입
//객체 <-> Json
//외부표현은 예를들어 Json 같은 타입
//Codable 을 채택한다는 것은 Encoding , decoding 을 할 수 있다.
struct WeatherInformation : Codable {
    let weather: [Weather]
    let temp : Temp
    let name : String
    
    enum CodingKeys: String , CodingKey{
        case weather
        case temp = "main"
        case name
    }
    
}

struct Weather : Codable {
    let id : Int
    let main : String
    let description : String
    let icon : String
    
}

//Json 키와 구조체에 선언된 키가 달라도 매핑 할 수 있도록 한다.
//이때 사용은 CodingKey를 사용한다.
//struct 의 변수 명과 enum 의 변수명이 다르면 Encodable / Decodable 에러가 발생 할 수 있다.
struct Temp : Codable {
    let temp : Double
    let feelslike : Double
    let minTemp : Double
    let maxTemp : Double
    
    enum CodingKeys: String, CodingKey{
        case temp
        case feelslike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}

