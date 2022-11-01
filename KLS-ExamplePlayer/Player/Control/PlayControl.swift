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
    
    var playerTypeLabel = UILabel()
    var playbackRateLabel = UILabel()
    
    //tag 1
    var playButton = UIButton()
    //tag 2
    var rewindButton = UIButton()
    //tag 3
    var forwardButton = UIButton()
    //tag 4
    var repeatButton = UIButton()
    //tag 5
    var reducePlaybackRateButton = UIButton()
    //tag 6
    var increasePlaybackRateButton = UIButton()
    //tag 7
    var muteButton = UIButton()
    
    //tag 1
    var progressSlider = CustomSlider()
    //tag 2
    var volumeSlider = (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first) as! UISlider
    
    
    public var PlayerType: String? {
        get {
            return self.playerTypeLabel.text
        }
        set (value) {
            self.playerTypeLabel.text = value
        }
    }
    public var PlaybackRate: String? {
        get {
            return self.playbackRateLabel.text
        }
        set (value){
            self.playbackRateLabel.text = value
        }
    }
    public var delegate :PlayerControlDelegate
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
        self.addSubview(playerTypeLabel)
        self.addSubview(rewindButton)
        self.addSubview(forwardButton)
        self.addSubview(repeatButton)
        self.addSubview(reducePlaybackRateButton)
        self.addSubview(playbackRateLabel)
        self.addSubview(increasePlaybackRateButton)
        self.addSubview(muteButton)
        self.addSubview(volumeSlider)
        self.bringSubviewToFront(progressSlider)
        self.isUserInteractionEnabled = true
        
        
        
        
        
        
        //재생 버튼
        playButton.setImage(UIImage(named: "btn-play"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        playButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        playButton.tag = 1
        playButton.addTarget(self, action: #selector(touchInsideButton), for: .touchUpInside)
        //플레이어 타입 라벨
        playerTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        playerTypeLabel.backgroundColor = UIColor.red
        playerTypeLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 5).isActive = true
        playerTypeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //뒤로가기 버튼
        rewindButton.setImage(UIImage(systemName: "backward.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rewindButton.tintColor = .white
        rewindButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        rewindButton.translatesAutoresizingMaskIntoConstraints = false
        rewindButton.leadingAnchor.constraint(equalTo: playerTypeLabel.trailingAnchor).isActive = true
        rewindButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rewindButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        rewindButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        rewindButton.tag = 2
        rewindButton.addTarget(self, action: #selector(touchInsideButton), for: .touchUpInside)
        //앞가기 버튼
        forwardButton.setImage(UIImage(systemName: "forward.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        forwardButton.tintColor = .white
        forwardButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.leadingAnchor.constraint(equalTo: rewindButton.trailingAnchor).isActive = true
        forwardButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        forwardButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        forwardButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        forwardButton.tag = 3
        forwardButton.addTarget(self, action: #selector(touchInsideButton), for: .touchUpInside)
        //구간반복버튼
        repeatButton.setImage(UIImage(named: "repeat-ab"), for: .normal)
        repeatButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        repeatButton.translatesAutoresizingMaskIntoConstraints = false
        repeatButton.leadingAnchor.constraint(equalTo: forwardButton.trailingAnchor).isActive = true
        repeatButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        repeatButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        repeatButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        repeatButton.tag = 4
        repeatButton.addTarget(self, action: #selector(touchInsideButton), for: .touchUpInside)
        //배속감소버튼
        reducePlaybackRateButton.setImage(UIImage(systemName:  "minus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        reducePlaybackRateButton.tintColor = .white
        reducePlaybackRateButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        reducePlaybackRateButton.translatesAutoresizingMaskIntoConstraints = false
        reducePlaybackRateButton.leadingAnchor.constraint(equalTo: repeatButton.trailingAnchor).isActive = true
        reducePlaybackRateButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        reducePlaybackRateButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        reducePlaybackRateButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        reducePlaybackRateButton.tag = 5
        reducePlaybackRateButton.addTarget(self, action: #selector(touchInsideButton), for: .touchUpInside)
        
        //배속 설정값 라벨
        playbackRateLabel.text = "1.0"
        playbackRateLabel.translatesAutoresizingMaskIntoConstraints = false
        playbackRateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        playbackRateLabel.leadingAnchor.constraint(equalTo: reducePlaybackRateButton.trailingAnchor, constant: 5).isActive = true
        playbackRateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //베속증가버튼
        increasePlaybackRateButton.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        increasePlaybackRateButton.tintColor = .white
        increasePlaybackRateButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        increasePlaybackRateButton.translatesAutoresizingMaskIntoConstraints = false
        increasePlaybackRateButton.leadingAnchor.constraint(equalTo: playbackRateLabel.trailingAnchor, constant: 5).isActive = true
        increasePlaybackRateButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        increasePlaybackRateButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        increasePlaybackRateButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        increasePlaybackRateButton.tag = 6
        increasePlaybackRateButton.addTarget(self, action: #selector(touchInsideButton), for: .touchUpInside)
        //음소거버튼
        muteButton.setImage(UIImage(named: "icon-volume"), for: .normal)
        muteButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.trailingAnchor.constraint(equalTo: volumeSlider.leadingAnchor, constant: -20).isActive = true
        muteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        muteButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        muteButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        muteButton.tag = 7
        muteButton.addTarget(self, action: #selector(touchInsideButton), for: .touchUpInside)
        //볼륨 슬라이더
        volumeSlider.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        volumeSlider.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        volumeSlider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        volumeSlider.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        volumeSlider.tag = 2
        volumeSlider.addTarget(self, action: #selector(valueChangedSlider), for: .valueChanged)
        //프로그래스바
        progressSlider.translatesAutoresizingMaskIntoConstraints = false;
        progressSlider.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        progressSlider.topAnchor.constraint(equalTo: self.topAnchor, constant: -30).isActive = true
        progressSlider.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        progressSlider.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: -8).isActive = true
        progressSlider.tag = 1
        progressSlider.addTarget(self, action: #selector(valueChangedSlider), for: .valueChanged)
    }
    
    @objc
    func touchInsideButton(_ sender: UIButton!){
        let _buttonType: ButtonType = ButtonType(rawValue: (sender as UIButton).tag)!
        NSLog("Player Control Touched \()", <#T##args: CVarArg...##CVarArg#>)
        switch _buttonType {
        case .play:
            
            break
        case .rewind:
            break
        case .forward:
            break
        case .repeatPlay:
            break
        case .reducePlaybackRate:
            break
        case .increasePlaybackRate:
            break
        case .mute:
            break
        default:
            break
        }
    }
    @objc
    func valueChangedSlider(_ sender: UISlider!){
        let _sliderType: SliderType = SliderType(rawValue: (sender as UISlider).tag)!
        switch _sliderType {
        case .progress:
            break
        case .volume:
            break
        default:
            break
        }
    }
    
}
