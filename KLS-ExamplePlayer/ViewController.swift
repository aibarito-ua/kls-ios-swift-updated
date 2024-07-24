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
        player = ExamplePlayer(frame: self.view.bounds, contentURL:"http://v.kr.kollus.com/si?jwt=eyJ0eXAiOiAiSldUIiwgImFsZyI6ICJIUzI1NiJ9.eyJjdWlkIjogIjgwMDcyNDUiLCJleHB0IjogMTcyMTgxNjQyNiwibWMiOiBbeyJtY2tleSI6IjZsbExDRWNYLTEyODMzNTAiLCJtY3BmIjoidHRzY2hvb2wtcGMxLWhkIiwidGh1bWJuYWlsIjp7ImVuYWJsZSI6dHJ1ZSwidHlwZSI6InNtYWxsIn19XX0.UFs5yG-E8hZI7S0Xik-KQS-YApVkNRRH3rMkbXr-wlw&custom_key=a40b9f2869716f3c4b82c7af066468d0b973dbfd572a6c4395ad99771ff76feb&uservalue0=6228984")
        self.view.addSubview(player)
        player.translatesAutoresizingMaskIntoConstraints = false
        player.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        player.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        player.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        player.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

