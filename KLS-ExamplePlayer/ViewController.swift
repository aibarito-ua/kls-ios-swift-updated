//
//  ViewController.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/14.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let topbar: Topbar = Topbar()
    let liveControl : LiveControl = LiveControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .purple
        self.view.addSubview(topbar)
//        self.view.addSubview(liveControl)
                
        topbar.translatesAutoresizingMaskIntoConstraints = false
        topbar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        topbar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        topbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topbar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        topbar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        topbar.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        
        
        liveControl.translatesAutoresizingMaskIntoConstraints = false
        liveControl.backgroundColor = UIColor.purple.withAlphaComponent(0.1)
        liveControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        liveControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
//        liveControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    liveControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        liveControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        liveControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        liveControl.backgroundColor = UIColor.gray.withAlphaComponent(0.7)

        topbar.backButton.addTarget(self, action: #selector(backbutton_pressed), for: .touchUpInside)
    }
    @objc
    func backbutton_pressed(sender: UIButton!){
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("viewWillTransition")
    }

}

