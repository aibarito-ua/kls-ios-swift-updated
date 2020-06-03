//
//  LiveControl.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/14.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit

class LiveControl: AbstractView {
    var playButton = UIButton()
    var liveLabel = UILabel()
    var muteButton = UIButton()
    var volumeSlider = CustomSlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        setupView()
    }
    
    func setupView(){
        self.addSubview(playButton)
        self.addSubview(liveLabel)
        self.addSubview(muteButton)
        self.addSubview(volumeSlider)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        //뒤로 가기 버튼 설정
        playButton.setImage(UIImage(named: "btn-play"), for: .normal)
//        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.leadingAnchor.constraint(equalTo:self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        playButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //제목줄 설정
        liveLabel.text = "LIVE"
        liveLabel.translatesAutoresizingMaskIntoConstraints = false
        liveLabel.backgroundColor = UIColor.red
        liveLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 5).isActive = true
        liveLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        //chrome castbutton
        muteButton.setImage(UIImage(named: "icon-volume"), for: .normal)
        muteButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
//        muteButton.leadingAnchor.constraint(equalTo:titleLabel.trailingAnchor, constant: 5).isActive = true
        muteButton.trailingAnchor.constraint(equalTo: volumeSlider.leadingAnchor).isActive = true
        muteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        muteButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        muteButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        //화면 크기 조정 버튼
//        sizeButton.setImage(UIImage(named: "fit"), for: .normal)
        volumeSlider.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
//        volumeSlider.leadingAnchor.constraint(equalTo:muteButton.trailingAnchor, constant: 5).isActive = true
        volumeSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        volumeSlider.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        volumeSlider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        volumeSlider.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

}
