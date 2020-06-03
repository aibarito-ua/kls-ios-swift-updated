//
//  AbstractView.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/14.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit

@IBDesignable
class AbstractView: UIView {

   override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    private func setup() {
        backgroundColor = .clear
        guard let xibName = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last else {
            return
        }
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

}
extension NSObject {
    var className : String {
        return NSStringFromClass(type(of: self))
    }
}

