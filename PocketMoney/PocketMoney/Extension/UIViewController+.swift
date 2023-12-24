//
//  UIViewController+.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/21.
//

import UIKit

extension UIViewController {
    static func topViewController() -> UIViewController? {
        if let keyWindow = UIApplication.shared.keyWindow {
            if var viewController = keyWindow.rootViewController {
                while viewController.presentedViewController != nil {
                    viewController = viewController.presentedViewController!
                }
                return viewController
            }
        }
        return nil
    }
    func setNavigationBackgroundColor(color: UIColor?) {
        guard let frame = navigationController?.navigationBar.frame else { return }
        let v = UIView(frame: .init(x: 0, y: 0, width: frame.width, height: Constant.height * 100))
        v.backgroundColor = color
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        view.addSubview(v)
    }
    
    func appendNavigationLeftBackButton(color: UIColor = .white) {
        let imageName = "chevron.left.\(color == .black ? "black" : "white")"
        let backButtonSpacer = UIBarButtonItem()
        backButtonSpacer.width = -20
        let backButton = UIBarButtonItem(image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        
        let homeButton = UIBarButtonItem(image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapHomeButton))
        
        if navigationItem.leftBarButtonItems == nil {
            navigationItem.leftBarButtonItems = []
        }
        [backButtonSpacer, backButton].forEach { navigationItem.leftBarButtonItems?.append($0) }
        
        if navigationItem.rightBarButtonItems == nil {
            navigationItem.rightBarButtonItems = []
        }
        
        
        navigationItem.rightBarButtonItems?.append(homeButton)
    }
    
    func appendNavigationLeftCustomView(_ sender: UIView) {
        let titleLabel = UIBarButtonItem(customView: sender)
        
        if navigationItem.leftBarButtonItems == nil {
            let backButtonSpacer = UIBarButtonItem()
            backButtonSpacer.width = 10
            navigationItem.leftBarButtonItems = [backButtonSpacer]
        }
        navigationItem.leftBarButtonItems?.append(titleLabel)
    }
    
    func appendNavigationLeftLabel(title: String = "", color: UIColor = .black) {
        let label = UILabel()
        label.text = title
        label.textColor = color
//        label.font = .appleSDGoithcFont(size: 20, style: .bold)
        let titleLabel = UIBarButtonItem(customView: label)
        label.largeContentImageInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        titleLabel.imageInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        if navigationItem.leftBarButtonItems == nil {
            let backButtonSpacer = UIBarButtonItem()
            backButtonSpacer.width = 10
            navigationItem.leftBarButtonItems = [backButtonSpacer]
        }
        navigationItem.leftBarButtonItems?.append(titleLabel)
    }
    
    func appendNavigationRightLabel(_ sender: UIView) {
        let titleLabel = UIBarButtonItem(customView: sender)
        if navigationItem.rightBarButtonItems == nil {
            let backButtonSpacer = UIBarButtonItem()
            backButtonSpacer.width = 3
            navigationItem.rightBarButtonItems = [backButtonSpacer]
        }
        navigationItem.rightBarButtonItems?.append(titleLabel)
    }
    
    @objc
    func didTapBackButton() {
        if self.navigationController?.viewControllers.count == 1 {
            dismiss(animated: false)
            return
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    func didTapHomeButton() {
        dismiss(animated: false)
    }
}

