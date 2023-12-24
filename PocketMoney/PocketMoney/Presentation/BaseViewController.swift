//
//  BaseViewController.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    init() {
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hex: "#F9F9FBFF")
        appendNavigationLeftBackButton(color: .black)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBackgroundColor(color: .init(hex: "#F9F9FBFF"))
    }
}
