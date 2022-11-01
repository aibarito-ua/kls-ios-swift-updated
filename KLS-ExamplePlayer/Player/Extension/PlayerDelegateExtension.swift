//
//  PlayerDelegateExtension.swift
//  kls-ios-swift
//
//  Created by HyeonDeok Yang on 2022/07/20.
//  Copyright © 2022 양현덕. All rights reserved.
//

import Foundation

extension ExamplePlayer : KollusPlayerDelegate {
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, prepareToPlayWithError error: Error!) {
        if error != nil {
            NSLog("Prepared Error : %c", error.localizedDescription)
        }
        else {
            if self._kollusPlayer!.isLive {
                self._contentType = .LIVE
            } else {
                if self._kollusPlayer!.isAudioOnly {
                    self._contentType = .AOD
                } else { self._contentType = .VOD}
            }
            self._playControl?.PlayerType = self._contentType.rawValue
            self._kollusContent = self._kollusPlayer?.content
            self._coverImageURL =  self._kollusContent?.snapshot ?? ""
            self._duration = self._kollusContent!.duration
            self._playControl?.Duration = Float(self._duration)
            self._kollusPlayer?.scalingMode = .scaleAspectFit
            self._kollusPlayer?.repeatMode = .one
            self._playerStatus = .Prepared
            self._indicator.stopAnimating()
        
            self.setupNowPlaying(title: self._kollusContent?.title)
            self.setupRemoteTransportControls()
            self.setupPipController()
            
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, play userInteraction: Bool, error: Error!) {
        if error != nil {
            NSLog("Play Error : %c", error.localizedDescription)
        }
        else {
            self._playerStatus = .Playing
            self._indicator.stopAnimating()
        }
        
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, pause userInteraction: Bool, error: Error!) {
        if error != nil {
            NSLog("Pause Error : %c", error.localizedDescription)
        }
        else {
            self._playerStatus = .Paused
            let state = UIApplication.shared.applicationState
            if (state == .background || state == .inactive) && !userInteraction {
                do {
                    self._pipController?.startPictureInPicture()
                    try self.play()
                }
                catch {
                    NSLog("Background Play Error : %c", error.localizedDescription)
                }
            }
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, buffering: Bool, prepared: Bool, error: Error!) {
        if error != nil {
            NSLog("Status Changed : %c", error.localizedDescription)
        }
        else {
            if !prepared {
                self._playerStatus = .NotPrepared
            }
            if buffering {
                self._playerStatus = .Buffering
                self._indicator.startAnimating()
            }
            else {
                do {
                    try self.play()
                } catch {
                    NSLog("Play Error : %c", error.localizedDescription)
                }
            }
            
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, stop userInteraction: Bool, error: Error!) {
        if error != nil {
            NSLog("Stop Error : %c", error.localizedDescription)
        }
        else {
            self._playerStatus = .Paused
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, position: TimeInterval, error: Error!) {
        if error != nil {
            NSLog("Stop Error : %c", error.localizedDescription)
        }
        else {
            //RepeatMode
            self._currentTime = position
            self.delegate?.progress(position)
            if self._startPosition != 0 && self._endPosition != 0 && self._endPosition >= position{
                self._kollusPlayer?.currentPlaybackTime = self._startPosition
            }
            updateNowPlaying(isPause: false)
        }
    }
    
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, scroll distance: CGPoint, error: Error!) {
        if error != nil {
            NSLog("Scroll Error : %c", error.localizedDescription)
        }
        else {
            NSLog("Scroll : x - %f, y - %f", distance.x, distance.y)
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, zoom recognizer: UIPinchGestureRecognizer!, error: NSErrorPointer) {
        if error != nil {
            NSLog("Zoom Error : %c", error.debugDescription)
        }
        else {
            NSLog("Zoom : scale - %f", recognizer.scale)
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, naturalSize: CGSize) {
        
        NSLog("Origin Size : w - %f, h - %f", naturalSize.width, naturalSize.height)
        
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, playerContentMode: KollusPlayerContentMode, error: Error!) {
        if error != nil {
            NSLog("Change Content Mode Error : %c", error.debugDescription)
        }
        else {
            NSLog("ContentMode :  %c", String(reflecting: playerContentMode))
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, playerContentFrame contentFrame: CGRect, error: Error!) {
        if error != nil {
            NSLog("Change Frame Size Error : %c", error.debugDescription)
        }
        else {
            NSLog("Frame Size : w - %f, h - %f", contentFrame.width, contentFrame.height)
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, playbackRate: Float, error: Error!) {
        if error != nil {
            NSLog("Change playbackrate: %c", error.debugDescription)
        }
        else {
            NSLog("playbackrate : %f, h - %f", playbackRate)
            self.delegate?.playbackrate(playbackRate)
            self._playControl?.PlaybackRate = String(playbackRate)
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, repeat: Bool, error: Error!) {
        if error != nil {
            NSLog("Change repeat mode: %c", error.debugDescription)
        }
        else {
            NSLog("repeat mode : %c", String(`repeat`))
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, enabledOutput: Bool, error: Error!) {
        if error != nil {
            NSLog("Change tv out  mode: %c", error.debugDescription)
        }
        else {
            NSLog("tv out mode : %c", String(enabledOutput))
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, unknownError error: Error!) {
        if error != nil {
            NSLog("Unknown Error: %c", error.debugDescription)
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, framerate: Int32) {
        NSLog("framerate : %c", String(framerate))
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, lockedPlayer playerType: KollusPlayerType) {
        NSLog("Lock Player : %c", String(reflecting: playerType))
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, charset: UnsafeMutablePointer<CChar>!, caption: UnsafeMutablePointer<CChar>!) {
        //        let charSet = String(cString: charset)
        let subtitle = String(cString: caption)
        NSLog("Subtitle :\n%c", subtitle)
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, thumbnail isThumbnail: Bool, error: Error!) {
        if error != nil {
            NSLog("Download thumbnail image Error: %c", error.debugDescription)
        }
        else {
            NSLog("Download Thumbnail async : %c", String(isThumbnail))
        }
    }
    
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, mck: String!) {
        NSLog("Media Content Key : %c", mck)
    }
    
    func kollusPlayerView(_ view: KollusPlayerView!, height: Int32) {
        NSLog("View Height : %c", String(height))
    }
    
    
}
