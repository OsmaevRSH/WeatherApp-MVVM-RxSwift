//
//  ViewController.swift
//  WeatherApp-MVVM-RxSwift
//
//  Created by Руслан Осмаев on 15.05.2022.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultTemp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField
            .rx
            .text
            .orEmpty
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.cityRelay)
            .disposed(by: disposeBag)
        
        viewModel
            .temp
            .map({ temp in
                String(temp)
            })
            .bind(to: resultTemp.rx.text)
            .disposed(by: disposeBag)
    }
}

