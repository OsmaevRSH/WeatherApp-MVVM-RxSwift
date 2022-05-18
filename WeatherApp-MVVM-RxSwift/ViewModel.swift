//
//  ViewModel.swift
//  WeatherApp-MVVM-RxSwift
//
//  Created by Руслан Осмаев on 15.05.2022.
//

import RxCocoa
import RxSwift
import Foundation

class ViewModel {
    private let disposeBag = DisposeBag()
    
    public let cityRelay = PublishRelay<String>()
    public let temp = PublishRelay<Double>()
    
    init() {
        cityRelay
            .subscribe(onNext: { [weak self] cityName in
                self?.getWeather(city: cityName)
            })
            .disposed(by: disposeBag)
    }
    
    private func getWeather(city: String) {
        HttpService
            .shared
            .getWeather(city: city)
            .compactMap { weather in
                return weather.main?.temp
            }
            .asObservable()
            .bind(to: temp)
            .disposed(by: disposeBag)
    }
}
