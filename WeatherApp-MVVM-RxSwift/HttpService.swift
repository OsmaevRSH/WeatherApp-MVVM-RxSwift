//
//  HttpService.swift
//  WeatherApp-MVVM-RxSwift
//
//  Created by Руслан Осмаев on 15.05.2022.
//

import RxSwift
import RxCocoa
import Foundation

class HttpService {
    static let shared = HttpService()
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "f79fcc0b3457d2c73dfbb3a5328ce8ff"
    
    private func getResultURL(city: String) -> URL? {
        guard let url = URL(string: baseURL) else { return nil }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let qQuery = URLQueryItem(name: "q", value: city)
        let appidQuery = URLQueryItem(name: "appid", value: apiKey)
        let unitsQuery = URLQueryItem(name: "units", value: "metric")
        
        guard var urlComponents = urlComponents else { return nil }
        
        urlComponents.queryItems = [
            qQuery,
            appidQuery,
            unitsQuery
        ]
        
        return urlComponents.url
    }
        
    func getWeather(city: String) -> Single<WeatherModel> {
        return Single<WeatherModel>.create { single in
            let defaultSession = URLSession(configuration: .default)
            let url = self.getResultURL(city: city)!

            let dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    single(.failure(error))
                } else if let data = data {
                    if let responseString = try? JSONDecoder().decode(WeatherModel.self, from: data) {
                        single(.success(responseString))
                    }
                }
            }
            dataTask.resume()
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
}
