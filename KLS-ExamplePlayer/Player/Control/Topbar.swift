//
//  Topbar.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/14.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit

@IBDesignable
class Topbar: AbstractView {

    var backButton: UIButton! = UIButton()
    var titleLabel: UILabel! = UILabel()
    var castButton: UIButton! = UIButton()
    var sizeButton: UIButton! = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetup()

    }

    private func viewSetup() {
        self.addSubview(backButton)
        self.addSubview(titleLabel)
        self.addSubview(castButton)
        self.addSubview(sizeButton)

        self.insetsLayoutMarginsFromSafeArea = false

        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        castButton.translatesAutoresizingMaskIntoConstraints = false
        sizeButton.translatesAutoresizingMaskIntoConstraints = false

        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        titleLabel.text = "아싸아싸~~~~!!!"
        castButton.setImage(UIImage(named: "more-info"), for: .normal)
        castButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        sizeButton.setImage(UIImage(named: "fit"), for: .normal)
        sizeButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        let constraints = [
            //뒤로 가기 버튼 설정
            backButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backButton.widthAnchor.constraint(equalTo: self.heightAnchor),
            backButton.heightAnchor.constraint(equalTo: self.heightAnchor),

            //제목줄 설정
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 5.0),
            //titleLabel.trailingAnchor.constraint(equalTo: castButton.leadingAnchor),
//            titleLabel.widthAnchor.constraint(equalToConstant:
//            self.safeAreaLayoutGuide.widthAnchor
//            ),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            //chrome castbutton
//            castButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            castButton.trailingAnchor.constraint(equalTo: sizeButton.leadingAnchor),
            castButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            castButton.widthAnchor.constraint(equalTo: self.heightAnchor),
            castButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            //화면 크기 조정 버튼
//            sizeButton.leadingAnchor.constraint(equalTo: castButton.trailingAnchor, constant: 5),
            sizeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sizeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sizeButton.widthAnchor.constraint(equalTo: self.heightAnchor),
            sizeButton.heightAnchor.constraint(equalTo: self.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }


}
