//
//  TabButton.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/21.
//

import UIKit
extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
class TabButton: UIButton {
    
    func select() {
        setBackgroundColor(.init(hex: "#E6388DFF") ?? .clear, for: .normal)
        setTitleColor(.white, for: .normal)
    }
    
    func disSelect() {
        setBackgroundColor(.clear, for: .normal)
        setTitleColor(.init(hex: "#8E8E93FF"), for: .normal)
    }
    
    init(tag: Int, text: String) {
        super.init(frame: .zero)
        setBackgroundColor(.blue, for: .normal)
        self.tag = tag
        self.setTitle(text, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel!.font = .systemFont(ofSize: Constant.width * 14)
        self.titleLabel!.adjustsFontSizeToFitWidth = true
        self.layer.cornerRadius = 5
        clipsToBounds = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
