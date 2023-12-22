//
//  ViewController.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/21.
//

import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let webService = WebViewController(linkString: "http://pocketfe.165.192.105.60.nip.io")
        let webService = WebViewController(linkString: "http://localhost:3000")
    
        webService.modalPresentationStyle = .overFullScreen
        present(webService, animated: true)
    }
}
