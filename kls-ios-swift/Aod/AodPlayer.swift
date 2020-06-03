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


class AodPlayer: AbstractView, KollusPlayerDelegate, KollusPlayerDRMDelegate, KollusPlayerLMSDelegate, KollusPlayerBookmarkDelegate {


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
    var playUrl: String?
    private let kollusStorage: KollusStorage? = {
        let appDeletgate = UIApplication.shared.delegate as! AppDelegate
        return appDeletgate.kollusStorage
    }()
    private var isPrepared: Bool = false
    public var isPlaying: Bool = false
    var playerDelegate: PlayerDelegate?

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
        //play 리스트로 구성할때 사용
//        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
//            print("Pause command - is playing: \(self.player.isPlaying)")
//            if self.player.isPlaying {
//                self.pause()
//            }
//            if self.isPlayList == true {
//                self.releasePlayer()
//                self.initPlayer()
//                self.currentMedia = self.currentMedia - 1 <= -1 ? self.playUrlList.count - 1 : self.currentMedia - 1
//                self.loadContent(targetContent: self.currentMedia)
//                return .success
//            }
//            return .commandFailed
//        }
//        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
//            print("Pause command - is playing: \(self.player.isPlaying)")
//            if self.player.isPlaying {
//                self.pause()
//                return .success
//            }
//            if self.isPlayList == true {
//                self.releasePlayer()
//                self.initPlayer()
//                self.currentMedia = self.currentMedia + 1 >= self.playUrlList.count ? 0 : self.currentMedia + 1
//                self.loadContent(targetContent: self.currentMedia)
//                return .success
//            }
//            return .commandFailed
//        }
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

            if let image: UIImage = UIImage(data: posterData)! {
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


    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, prepareToPlayWithError error: Error!) {
        self.indicator.stopAnimating()
        if error != nil {
            print("Prepare Error: ", error.debugDescription)
        } else {
            do {
                self.isPrepared = true
                print(kollusPlayer.content.thumbnail)
                let posterUrl: URL = try URL(fileURLWithPath: kollusPlayerView.content.snapshot)
                let posterData = try Data(contentsOf: posterUrl)
                let posterImage: UIImage = UIImage(data: posterData)!
                self.posterImageView.image = posterImage
            } catch {
                print("포스터 이미지를 불러 올수 없습니다.")
            }
            self.setupNowPlaying(title: kollusPlayerView.content.title)
            self.setupRemoteTransportControls()
            playerDelegate?.prepared(title: kollusPlayerView.content.title, duration: kollusPlayerView.content.duration)
        }
    }


    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, play userInteraction: Bool, error: Error!) {
        self.isPlaying = true
        runTimer()
    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, pause userInteraction: Bool, error: Error!) {
        self.isPlaying = false
        let state = UIApplication.shared.applicationState
        if (state == .background || state == .inactive) && !userInteraction {
            self.playAndPause()
        }
        stopTimer()

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, buffering: Bool, error: Error!) {
        if buffering {
            self.indicator.startAnimating()
        }
    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, stop userInteraction: Bool, error: Error!) {
        self.isPlaying = false
        self.isPrepared = false
        self.releasePlayer()
    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, position: TimeInterval, error: Error!) {
        print("Progress Event Raise", position)
        playerDelegate?.progress(position: position, duration: kollusPlayerView.content.duration)
    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, scroll distance: CGPoint, error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, zoom recognizer: UIPinchGestureRecognizer!, error: NSErrorPointer) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, naturalSize: CGSize) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, playerContentMode: KollusPlayerContentMode, error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, playerContentFrame contentFrame: CGRect, error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, playbackRate: Float, error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, repeat: Bool, error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, enabledOutput: Bool, error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, unknownError error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, framerate: Int32) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, lockedPlayer playerType: KollusPlayerType) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, charset: UnsafeMutablePointer<Int8>!, caption: UnsafeMutablePointer<Int8>!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, thumbnail isThumbnail: Bool, error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, mck: String!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, request: [AnyHashable: Any]!, json: [AnyHashable: Any]!, error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, json: [AnyHashable: Any]!, error: Error!) {

    }

    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, bookmark bookmarks: [Any]!, enabled: Bool, error: Error!) {

    }


}
