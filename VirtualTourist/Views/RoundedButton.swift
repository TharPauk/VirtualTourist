//
//  RoundedButton.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 22/05/2021.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    fileprivate func setupBlurView() {
        backgroundColor = .systemBackground
        let blur = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blur)

        blurView.frame = self.bounds
        insertSubview(blurView, at: 0)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBlurView()
        layer.cornerRadius = cornerRadius
    }

}
