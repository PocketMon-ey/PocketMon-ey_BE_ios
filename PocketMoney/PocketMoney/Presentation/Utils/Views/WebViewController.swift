//
//  WebViewController.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/21.
//

import UIKit
import SnapKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    // MARK: - Properties
    var linkString: String
    
    // MARK: - Initializer
    init(linkString: String) {
        self.linkString = linkString
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration.userContentController.add(self, name: "PocketMoney")
        setUI( )
        loadWebView()
    }
    
    func loadWebView() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let url = URL(string: self?.linkString ?? "") else {
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
                return
            }
            print(url)
            let request = URLRequest(url: url)
            
            DispatchQueue.main.async {
                self?.webView.load(request)
            }
        }
    }
    
    // MARK: - UIComponents
    let configuration: WKWebViewConfiguration = {
        return $0
    }(WKWebViewConfiguration())
    lazy var webView: WKWebView = {
        $0.uiDelegate = self
        $0.navigationDelegate = self
        return $0
    }(WKWebView(frame: .zero, configuration: configuration))
    
    var indicator = UIActivityIndicatorView()
    
    func setUI() {
        [webView, indicator].forEach { view.addSubview($0) }
        
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "PocketMoney" {
            print(message.body)
            let m = (message.body as! String).components(separatedBy: " ")
            UserDefaultManager.userId = 2
            UserDefaultManager.isChild = m[1] == "1"
            
            let vc = UINavigationController(rootViewController: MissionHomeViewController(viewModel: .init()))
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: false)
        }
    }
}
