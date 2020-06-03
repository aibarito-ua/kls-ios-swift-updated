//
//  LivePlayerController.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/14.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit

class LivePlayerController: UIViewController {

    let topbar: Topbar = Topbar()
    let liveControl: LiveControl = LiveControl()
    let urlView: UrlView = UrlView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.addView()
        self.setupConstraint()
        self.setupEventHandler()

    }

    private func addView() {
        self.view.addSubview(topbar)
        self.view.addSubview(liveControl)
        self.view.addSubview(urlView)
    }

    private func setupConstraint() {
        topbar.translatesAutoresizingMaskIntoConstraints = false
        liveControl.translatesAutoresizingMaskIntoConstraints = false
        urlView.translatesAutoresizingMaskIntoConstraints = false

        topbar.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        liveControl.backgroundColor = UIColor.purple.withAlphaComponent(0.1)
        urlView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        urlView.isHidden = true

        let constraints = [
            topbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//        topbar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            topbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topbar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            topbar.heightAnchor.constraint(equalToConstant: 40),


            liveControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//        liveControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            //        liveControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            liveControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            liveControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            liveControl.heightAnchor.constraint(equalToConstant: 40),


//        urlView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            urlView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            urlView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            urlView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            urlView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
        ]
        NSLayoutConstraint.activate(constraints)

    }

    private func setupEventHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        topbar.backButton.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside)
        topbar.castButton.addTarget(self, action: #selector(pressedCastButton), for: .touchUpInside)
        topbar.sizeButton.addTarget(self, action: #selector(pressedSizeButton), for: .touchUpInside)

        liveControl.playButton.addTarget(self, action: #selector(pressedPlayButton), for: .touchUpInside)
        liveControl.muteButton.addTarget(self, action: #selector(pressedMuteButton), for: .touchUpInside)
        liveControl.volumeSlider.addTarget(self, action: #selector(valueChangedVolumeSlider), for: .valueChanged)
    }

    @objc
    func viewTapped(sender: UITapGestureRecognizer) {
        print("TAP!!")
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.topbar.isHidden = !self.topbar.isHidden
            self.liveControl.isHidden = !self.liveControl.isHidden
        })

    }

    @objc
    func pressedBackButton(sender: UIButton!) {
        print("backbutton")
    }

    @objc
    func pressedCastButton(sender: UIButton!) {
        print("castbutton")
//        self.urlView.isHidden = !self.urlView.isHidden
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.urlView.isHidden = !self.urlView.isHidden
        })
    }

    @objc
    func pressedSizeButton(sender: UIButton!) {
        print("sizebutton")
    }

    @objc
    func pressedPlayButton(sender: UIButton!) {
        print("playbutton")
    }

    @objc
    func pressedMuteButton(sender: UIButton!) {
        print("mutebutton")
    }

    @objc
    func valueChangedVolumeSlider(sender: UISlider!) {
        print("slider")
        print(liveControl.volumeSlider.value)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
