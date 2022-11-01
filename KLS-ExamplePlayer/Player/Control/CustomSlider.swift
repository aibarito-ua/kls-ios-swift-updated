//
//  CustomSlider.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/15.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    @IBInspectable var trackHeight: CGFloat = 5
    @IBInspectable var thumbRadius: CGFloat = 5

    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .purple
        thumb.layer.borderWidth = 1
        thumb.layer.borderColor = UIColor.red.cgColor
        thumb.tintColor = .blue
        return thumb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    private func setup() {
        let thumb = makeThumbImage(radius: thumbRadius)
        self.setThumbImage(thumb, for: .normal)
        self.minimumTrackTintColor = UIColor.red
        self.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.7)
    }

    private func makeThumbImage(radius: CGFloat) -> UIImage {
        self.thumbView.frame = CGRect(x:0.0, y:radius / 2, width: radius/2, height: radius*2)
//        self.thumbView.layer.cornerRadius = radius / 2
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { context in thumbView.layer.render(in: context.cgContext) }

    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}
