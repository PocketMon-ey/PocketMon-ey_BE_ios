//
//  NavigationController.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/21.
//

import UIKit

class NavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
