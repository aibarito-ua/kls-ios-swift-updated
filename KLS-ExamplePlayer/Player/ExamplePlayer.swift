//
//  AodPlayer.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/27.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import AVFoundation

protocol PlayerDelegate {
    func prepared(title: String, duration: TimeInterval)
    func pause()
    func progress(position: TimeInterval, duration: TimeInterval)
}


class ExamplePlayer: AbstractView {


    var playUrl: String?
    private var isPrepared: Bool = false
    public var isPlaying: Bool = false
    var playerDelegate: PlayerDelegate?
    
    public var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.note")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let indicator: UIActivityIndicatorView = {
        let uiIndicator = UIActivityIndicatorView()
        uiIndicator.hidesWhenStopped = true
        uiIndicator.color = .white
        return uiIndicator
    }()
    private var kollusPlayer: KollusPlayerView! = {
        let player = KollusPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()
    
    private let kollusStorage: KollusStorage? = {
        let appDeletgate = UIApplication.shared.delegate as! AppDelegate
        return appDeletgate.kollusStorage
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        self.backgroundColor = .white
    }

    public func setPlayerUrl(string: String) {
        self.playUrl = string
        releasePlayer()
        initPlayer()
    }

    private func initPlayer() {
        self.kollusPlayer = {
            let player = KollusPlayerView()
            player.translatesAutoresizingMaskIntoConstraints = false
            player.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            player.storage = self.kollusStorage
            player.contentURL = self.playUrl
            player.debug = true
            return player
        }()
        
        self.addSubview(kollusPlayer)
        kollusPlayer.delegate = self
        kollusPlayer.drmDelegate = self
        kollusPlayer.lmsDelegate = self
        kollusPlayer.bookmarkDelegate = self

        do {
            self.indicator.startAnimating()
            try self.kollusPlayer.prepareToPlay(withMode: .PlayerTypeNative)
        } catch {
            print("컨텐츠 준비중 에러 발생: ", error.localizedDescription)
        }
    }

    private func releasePlayer() {
        if kollusPlayer != nil {
            do {
                if kollusPlayer.storage == nil {
                    kollusPlayer.storage = self.kollusStorage
                }
                try self.kollusPlayer.stop()
                self.kollusPlayer.removeFromSuperview()
            } catch {
                print("Player Release Error: ", error.localizedDescription)
            }
        }
    }


    private func setupView() {

        self.addSubview(posterImageView)
        self.addSubview(indicator)
        posterImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        posterImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        self.indicator.center = self.center
    }

    func playAndPause() -> Bool {
        if isPrepared {
            if !isPlaying {
                do {
                    try kollusPlayer.play()
                    return true
                } catch {
                    print("Player Play: ", error.localizedDescription)
                }
            } else {
                do {
                    try kollusPlayer.pause()
                    return false
                } catch {
                    print("Player pause: ", error.localizedDescription)
                }
            }
        }
        return false
    }

    var savedVolume: Float = 0.0


    func reward() -> Bool {
        if isPrepared && isPlaying {
            DispatchQueue.main.async {
                let position: TimeInterval = self.kollusPlayer.currentPlaybackTime
                self.kollusPlayer.currentPlaybackTime = position - 5
            }
            return true
        }
        return false
    }

    func forward() -> Bool {
        if isPrepared && isPlaying {
            DispatchQueue.main.async {
                let position: TimeInterval = self.kollusPlayer.currentPlaybackTime
                self.kollusPlayer.currentPlaybackTime = position + 5
            }
            return true
        }
        return false
    }
    func decreasePlaybackRate() -> Float {
        if isPrepared && isPlaying {
            let playbackRate: Float = kollusPlayer.currentPlaybackRate
            if playbackRate > -2.0 {
                kollusPlayer.currentPlaybackRate = playbackRate - 0.1
                return kollusPlayer.currentPlaybackRate
            }
        }
        return kollusPlayer.currentPlaybackRate
    }

    func increasePlaybackRate() -> Float {
        if isPrepared && isPlaying {
            let playbackRate: Float = kollusPlayer.currentPlaybackRate
            if playbackRate < 2.0 {
                kollusPlayer.currentPlaybackRate = playbackRate + 0.1
                return kollusPlayer.currentPlaybackRate
            }
        }
        return kollusPlayer.currentPlaybackRate
    }

    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.playAndPause()
            return .success
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            print("Pause command - is playing: \(self.isPlaying)")
            self.playAndPause()
            return .success
        }
        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(onChangePlaybackPositionCommand))
    }

    @objc
    func onChangePlaybackPositionCommand(event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("event position time: \(event.positionTime)")
        DispatchQueue.main.async {
            self.kollusPlayer.currentPlaybackTime = event.positionTime
        }
        return MPRemoteCommandHandlerStatus.success
    }

    func setupNowPlaying(title: String!) {

//        let dq = DispatchQueue.global(qos: .background)
//        dq.async {
        // Define Now Playing Info
        do {
            var nowPlayingInfo = [String: Any]()
            let posterUrl: URL = try URL(fileURLWithPath: kollusPlayer.content.snapshot)
            let posterData = try Data(contentsOf: posterUrl)

            if let image: UIImage = UIImage(data: posterData) {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
                }
            }
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = kollusPlayer.currentPlaybackTime
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = kollusPlayer.content.duration
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = kollusPlayer.currentPlaybackRate

            // Set the metadata
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
//        }
        } catch {
            print("MP Player Setting Error", error.localizedDescription)
        }

    }
    func updateNowPlaying(isPause: Bool) {
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = kollusPlayer.currentPlaybackTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0 : 1

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    var timer: Timer?
    func runTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.playerDelegate?.progress(position: self.kollusPlayer.currentPlaybackTime, duration: self.kollusPlayer.content.duration)
        })
    }
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }


    
}
