//
//  UrlView.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/14.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit

class UrlView: AbstractView {
    var urlText:UITextView! = UITextView()
    var okButton: UIButton! = UIButton()
    var cancelButton: UIButton! = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        setup()
    }
    
    private func setup(){
        self.addSubview(urlText)
        self.addSubview(okButton)
        self.addSubview(cancelButton)

        urlText.translatesAutoresizingMaskIntoConstraints = false
        urlText.layer.masksToBounds = true
        urlText.layer.borderColor = UIColor.red.cgColor
        urlText.layer.borderWidth = 1.0
        urlText.addDoneButton(title: "완료", target: self, selector: #selector(tapDone))


        okButton.setTitle("이동", for: .normal)
        okButton.setTitleColor(.black, for: .normal)
        okButton.layer.masksToBounds = true
        okButton.layer.borderColor = UIColor.blue.cgColor
        okButton.layer.borderWidth = 1.0
        okButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false



        urlText.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        urlText.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        urlText.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        urlText.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true

        okButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        okButton.trailingAnchor.constraint(equalTo: self.cancelButton.leadingAnchor).isActive = true
        okButton.topAnchor.constraint(equalTo: self.urlText.bottomAnchor).isActive = true
//        okButton.bottomAnchor.constraint(equalTo: self,.bottomAnchor).isActive = true
        okButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
        okButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true

        cancelButton.leadingAnchor.constraint(equalTo: okButton.trailingAnchor).isActive = true
//        cancelButton.trailingAnchor.constraint(equalTo: self.cancelButton.leadingAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: self.urlText.bottomAnchor).isActive = true
//        cancelButton.bottomAnchor.constraint(equalTo: self,.bottomAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
    }
    @objc
    func tapDone(sender: Any) {
        self.endEditing(true)
    }
}
extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x:0.0, y:0.0, width:UIScreen.main.bounds.width, height: 40.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title:title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }

}
