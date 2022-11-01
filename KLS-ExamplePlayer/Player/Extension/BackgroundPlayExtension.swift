//
//  BackgroundPlayExtension.swift
//  KLS-ExamplePlayer
//
//  Created by HyeonDeok Yang on 2022/07/25.
//  Copyright © 2022 양현덕. All rights reserved.
//
import MediaPlayer
import AVFoundation

import Foundation
extension ExamplePlayer : AVPictureInPictureControllerDelegate  {
    
    @objc func appEnteredBackgound() {
        self.avPlayer = (self._kollusPlayer!.subviews.first?.layer.sublayers?.first as? AVPlayerLayer)?.player as! AVPlayer
        (self._kollusPlayer!.subviews.first?.layer.sublayers?.first as? AVPlayerLayer)?.player = nil
    }

    @objc func appEnteredForeground() {
        (self._kollusPlayer!.subviews.first?.layer.sublayers?.first as? AVPlayerLayer)?.player = avPlayer
        avPlayer = AVPlayer()
    }
    
    func setupRemoteTransportControls() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredBackgound), name: UIApplication.didEnterBackgroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Get the shared MPRemoteCommandCenter
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // 오디오 세션 카테고리, 모드, 옵션을 설정합니다.
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            
        } catch {
            print("Failed to set audio session category.")
        }
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            NSLog("Play command : %c", String(reflecting: self.PlayerStatus))
            do {
                try self.play()
            } catch {
                NSLog("Play command Fail: %c", String(reflecting: self.PlayerStatus))
                return .commandFailed
            }
            return .success
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            NSLog("Pause command : %c", String(reflecting: self.PlayerStatus))
            do {
                try self.pause()
            } catch {
                NSLog("Pause command Fail: %c", String(reflecting: self.PlayerStatus))
                return .commandFailed
            }
            return .success
        }
        commandCenter.skipBackwardCommand.addTarget{
            [unowned self] event in
            NSLog("backward command : %c", String(reflecting: self.PlayerStatus))
            do {
                try self.rewind()
            } catch {
                NSLog("backward command Fail: %c", String(reflecting: self.PlayerStatus))
                return .commandFailed
            }
            return .success
        }
        commandCenter.skipForwardCommand.addTarget{
            [unowned self] event in
            NSLog("forward command : %c", String(reflecting: self.PlayerStatus))
            do {
                try self.forward()
            } catch {
                NSLog("forward command Fail: %c", String(reflecting: self.PlayerStatus))
                return .commandFailed
            }
            return .success
        }
        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(onChangePlaybackPositionCommand))
    }
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeInt = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeInt) else {
            return
        }
        
        switch type {
        case .began: break
        case .ended:
            if let optionInt = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionInt)
                if options.contains(.shouldResume) {
                    do {
                        try self.play()
                    }catch{
                        
                    }
                }
            }
        }
    }
    @objc
    func onChangePlaybackPositionCommand(event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("event position time: \(event.positionTime)")
        DispatchQueue.main.async {
            do {
                NSLog("Seek command : %c", String(reflecting: self.PlayerStatus))
                try self.seek(position: event.positionTime)
            }
            catch {
                NSLog("Seek command Fail: %c", String(reflecting: self.PlayerStatus))
            }
        }
        return MPRemoteCommandHandlerStatus.success
    }
    
    func setupNowPlaying(title: String!) {
        do {
            var nowPlayingInfo = [String: Any]()
            let posterUrl: URL = try URL(fileURLWithPath: self.CoverImageURL)
            let posterData = try Data(contentsOf: posterUrl)
            
            if let image: UIImage = UIImage(data: posterData) {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
                }
            }
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.CurrentTime
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.Duration
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.PlaybackRate
            
            // Set the metadata
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            
            
        } catch {
            print("MP Player Setting Error", error.localizedDescription)
        }
        
    }
    func updateNowPlaying(isPause: Bool) {
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.CurrentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.PlaybackRate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupPipController() {
        if(AVPictureInPictureController.isPictureInPictureSupported()){
            self._pipController = AVPictureInPictureController(playerLayer: (self._kollusPlayer!.subviews.first?.layer.sublayers?.first as? AVPlayerLayer)!)
            self._pipController?.delegate = self
        }
        else {
            NSLog("Not Supported PIP")
        }
    }
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        NSLog("PIP DELEGATE : pictureInPictureControllerWillStartPictureInPicture")
    }
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        NSLog("PIP DELEGATE : pictureInPictureControllerDidStartPictureInPicture")
    }
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error){
        NSLog("PIP DELEGATE : failedToStartPictureInPictureWithError")
        if error != nil {
            NSLog(error.localizedDescription)
        }
    }
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController){
        NSLog("PIP DELEGATE : pictureInPictureControllerWillStopPictureInPicture")
    }
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        NSLog("PIP DELEGATE : pictureInPictureControllerDidStopPictureInPicture")
    }
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        NSLog("PIP DELEGATE : restoreUserInterfaceForPictureInPictureStopWithCompletionHandler")
    }
}
