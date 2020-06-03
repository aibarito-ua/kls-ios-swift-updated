//
//  PlayControl.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/27.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit
import MediaPlayer
class PlayControl: UIView {

    var playButton = UIButton()
    var label = UILabel()
    var prevStepButton = UIButton()
    var nextStepButton = UIButton()
    var repeatButton = UIButton()
    var playRateLabel = UILabel()
    var reducePlayRateButton = UIButton()
    var increasePlayRateButton = UIButton()


    var muteButton = UIButton()
    var volumeSlider = (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first) as! UISlider
    var progressSlider = CustomSlider()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {

        self.addSubview(progressSlider)
        self.addSubview(playButton)
        self.addSubview(label)
        self.addSubview(prevStepButton)
        self.addSubview(nextStepButton)
//        self.addSubview(repeatButton)
        self.addSubview(reducePlayRateButton)
        self.addSubview(playRateLabel)
        self.addSubview(increasePlayRateButton)
        self.addSubview(muteButton)
        self.addSubview(volumeSlider)
        self.bringSubviewToFront(progressSlider)
        self.isUserInteractionEnabled = true


        progressSlider.translatesAutoresizingMaskIntoConstraints = false;
        progressSlider.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        progressSlider.topAnchor.constraint(equalTo: self.topAnchor, constant: -30).isActive = true
        progressSlider.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        progressSlider.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: -8).isActive = true



        //재생 버튼
        playButton.setImage(UIImage(named: "btn-play"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        playButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        //제목줄 설정
        label.text = "AOD"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.red
        label.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 5).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        //5초이전버튼
        

        
        prevStepButton.setImage(UIImage(systemName: "backward.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        prevStepButton.tintColor = .white
        prevStepButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        prevStepButton.translatesAutoresizingMaskIntoConstraints = false
        prevStepButton.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        prevStepButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        prevStepButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        prevStepButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        //5초앞으로버튼
        nextStepButton.setImage(UIImage(systemName: "forward.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        nextStepButton.tintColor = .white
        nextStepButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        nextStepButton.leadingAnchor.constraint(equalTo: prevStepButton.trailingAnchor).isActive = true
        nextStepButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nextStepButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        nextStepButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

//        //구간반복버튼
//        repeatButton.setImage(UIImage(named: "repeat-ab"), for: .normal)
//        repeatButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        repeatButton.translatesAutoresizingMaskIntoConstraints = false
//        repeatButton.leadingAnchor.constraint(equalTo: nextStepButton.trailingAnchor).isActive = true
//        repeatButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        repeatButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//        repeatButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true



        //배속감소버튼
        reducePlayRateButton.setImage(UIImage(systemName:  "minus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        reducePlayRateButton.tintColor = .white
        reducePlayRateButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        reducePlayRateButton.translatesAutoresizingMaskIntoConstraints = false
        reducePlayRateButton.leadingAnchor.constraint(equalTo: nextStepButton.trailingAnchor).isActive = true
        reducePlayRateButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        reducePlayRateButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        reducePlayRateButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        //배속 설정값 라벨
        playRateLabel.text = "1.0"
        playRateLabel.translatesAutoresizingMaskIntoConstraints = false
        playRateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        playRateLabel.leadingAnchor.constraint(equalTo: reducePlayRateButton.trailingAnchor, constant: 5).isActive = true
        playRateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        //베속증가버튼
        increasePlayRateButton.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        increasePlayRateButton.tintColor = .white
        increasePlayRateButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        increasePlayRateButton.translatesAutoresizingMaskIntoConstraints = false
        increasePlayRateButton.leadingAnchor.constraint(equalTo: playRateLabel.trailingAnchor, constant: 5).isActive = true
        increasePlayRateButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        increasePlayRateButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        increasePlayRateButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        
        //볼륨버튼
        muteButton.setImage(UIImage(named: "icon-volume"), for: .normal)
        muteButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.trailingAnchor.constraint(equalTo: volumeSlider.leadingAnchor, constant: -20).isActive = true
        muteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        muteButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        muteButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //볼륨 슬라이더

        volumeSlider.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        volumeSlider.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        volumeSlider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        volumeSlider.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

}
