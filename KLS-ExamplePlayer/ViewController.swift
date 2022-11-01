//
//  ViewController.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/14.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var player : ExamplePlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        player = ExamplePlayer(frame: self.view.bounds, contentURL:"https://v.kr.kollus.com/si?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtYyI6W3sibWNrZXkiOiI4eXY2VHJnQiIsIm1jcGYiOiJpa3dvbnNlby1tb2JpbGUxLW5vcm1hbCJ9XSwiY3VpZCI6InRlc3QzMzMiLCJleHB0IjoxOTQyMTM2NTQ1fQ.C2a-9MZIg_mUJxc90v04A_fUDyhmbpMSVsECgF51z68&custom_key=53d759b68288316c4fe0e403702473998ec4495fc4c31a647c9cd39017d961a3")
        self.view.addSubview(player)
        player.translatesAutoresizingMaskIntoConstraints = false
        player.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        player.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        player.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        player.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

