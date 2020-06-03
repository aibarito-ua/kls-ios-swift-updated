//
//  AodPlayerController.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/27.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class AodPlayerController: UIViewController, PlayerDelegate {
    func progress(position: TimeInterval, duration: TimeInterval) {
        DispatchQueue.main.async {
            self.aodControl.progressSlider.setValue(Float(position), animated: true)
            print(self.aodControl.progressSlider.value)
        }

    }

    func prepared(title: String, duration: TimeInterval) {
        self.topbar.titleLabel.text = title
        self.aodControl.progressSlider.maximumValue = Float(duration)
    }

    func pause() {
        print("PAAAAUUUUSSSEEEE")
    }


    let topbar: Topbar = Topbar()
    let aodControl: PlayControl = PlayControl()
    let urlView: UrlView = UrlView()
    let player: AodPlayer = AodPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        player.setPlayerUrl(string: "https://v.kr.kollus.com/i/mQVfrp0i?")
        self.addView()
        self.setupConstraint()
        self.setupEventHandler()

    }

    private func addView() {
        self.view.addSubview(player)

        self.view.addSubview(topbar)
        self.view.addSubview(aodControl)
        aodControl.volumeSlider.setValue(AVAudioSession.sharedInstance().outputVolume, animated: true)
        self.player.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(urlView)
        player.backgroundColor = .purple

        self.view.bringSubviewToFront(player)
    }

    private func setupConstraint() {
        topbar.translatesAutoresizingMaskIntoConstraints = false
        aodControl.translatesAutoresizingMaskIntoConstraints = false
        urlView.translatesAutoresizingMaskIntoConstraints = false

        topbar.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        aodControl.backgroundColor = UIColor.purple.withAlphaComponent(0.1)
        urlView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        urlView.isHidden = true

        let constraints: [NSLayoutConstraint] = [
            topbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topbar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            topbar.heightAnchor.constraint(equalToConstant: 40),


            aodControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            aodControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            aodControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            aodControl.heightAnchor.constraint(equalToConstant: 40),


            urlView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            urlView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            urlView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            urlView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),

            player.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            player.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            player.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            player.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        self.view.sendSubviewToBack(player)

    }

    private func setupEventHandler() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        player.posterImageView.addGestureRecognizer(tapGesture)
        player.posterImageView.addGestureRecognizer(tapGesture)
        player.addGestureRecognizer(tapGesture)

        player.playerDelegate = self

        topbar.backButton.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside)
        topbar.castButton.addTarget(self, action: #selector(pressedCastButton), for: .touchUpInside)
        topbar.sizeButton.addTarget(self, action: #selector(pressedSizeButton), for: .touchUpInside)

        aodControl.playButton.addTarget(self, action: #selector(pressedPlayButton), for: .touchUpInside)
        aodControl.muteButton.addTarget(self, action: #selector(pressedMuteButton), for: .touchUpInside)
        aodControl.volumeSlider.addTarget(self, action: #selector(valueChangedVolumeSlider), for: .valueChanged)
        aodControl.progressSlider.addTarget(self, action: #selector(valueChangedProgressSlider), for: .valueChanged)
        aodControl.prevStepButton.addTarget(self, action: #selector(pressedPrevStepButton), for: .touchUpInside)
        aodControl.nextStepButton.addTarget(self, action: #selector(pressedNextStepButton), for: .touchUpInside)
        aodControl.reducePlayRateButton.addTarget(self, action: #selector(pressedReducePlayRateButton), for: .touchUpInside)
        aodControl.increasePlayRateButton.addTarget(self, action: #selector(pressedIncreasePlayRateButton), for: .touchUpInside)

        urlView.okButton.addTarget(self, action: #selector(okUrl), for: .touchUpInside)
        urlView.cancelButton.addTarget(self, action: #selector(cancelUrl), for: .touchUpInside)
    }

    @objc
    func viewTapped(sender: UITapGestureRecognizer) {
        print("TAP!!")
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.topbar.isHidden = !self.topbar.isHidden
            self.aodControl.isHidden = !self.aodControl.isHidden
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
        if self.player.playAndPause() {
            sender.setImage(UIImage(named: "btn-pause"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "btn-play"), for: .normal)
        }
    }

    @objc
    func pressedPrevStepButton(sender: UIButton!) {
        player.reward()
    }

    @objc
    func pressedNextStepButton(sender: UIButton!) {
        player.forward()
    }

    @objc
    func pressedReducePlayRateButton(sender: UIButton!) {
        let playRate = player.decreasePlaybackRate()
        aodControl.playRateLabel.text = String(format: "%.1f", playRate)
    }

    @objc
    func pressedIncreasePlayRateButton(sender: UIButton!) {
        let playRate = player.increasePlaybackRate()
        aodControl.playRateLabel.text = String(format: "%.1f", playRate)
    }

    @objc
    func pressedMuteButton(sender: UIButton!) {
        if AVAudioSession.sharedInstance().outputVolume > 0.0 {
            player.savedVolume = AVAudioSession.sharedInstance().outputVolume
            aodControl.muteButton.setImage(UIImage(named: "icon-volume-mute-on"), for: .normal)
            aodControl.volumeSlider.setValue(0.0, animated: true)
        } else {
            aodControl.volumeSlider.setValue(player.savedVolume, animated: true)
            aodControl.muteButton.setImage(UIImage(named: "icon-volume"), for: .normal)
        }
    }

    @objc
    func valueChangedVolumeSlider(sender: UISlider!) {
        print("slider")
        print(aodControl.volumeSlider.value)
        MPVolumeView.setVolume(aodControl.volumeSlider.value)
    }

    @objc
    func valueChangedProgressSlider(sender: UISlider!) {
        print("progress")
        print(aodControl.progressSlider.value)
    }

    @objc
    func okUrl(sender: UIButton!) {

        print("okUrl")
        print(urlView.urlText.text!)
        player.setPlayerUrl(string: urlView.urlText.text)
        urlView.isHidden = true
    }

    @objc
    func cancelUrl(sender: UIButton!) {

        print("cancelUrl")
        urlView.urlText.text = ""
        urlView.isHidden = true
    }
}

extension MPVolumeView {
    static func setVolume(_ value: Float) {
        (MPVolumeView().subviews.filter {
            NSStringFromClass($0.classForCoder) == "MPVolumeSlider"
        }.first as? UISlider)?.setValue(value, animated: false)
    }
}
