//
//  PlayerControlExtension.swift
//  KLS-ExamplePlayer
//
//  Created by HyeonDeok Yang on 2022/07/25.
//  Copyright © 2022 양현덕. All rights reserved.
//

import Foundation
extension ExamplePlayer : PlayerControlDelegate {
    func playTouched() {
        do {
            if self.PlayerStatus == .Paused || self.PlayerStatus == .Prepared {
                try self.play()
            }
            else if self.PlayerStatus == .Playing {
                try self.pause()
            }
        }catch {
            NSLog("PlayButton Touched Error", error.localizedDescription)
        }
    }
    
    func rewindTouched() {
        do {
            try self.rewind()
        }catch {
            NSLog("RewindButton Touched Error", error.localizedDescription)
        }
    }
    
    func forwardTouched() {
        do {
            try self.forward()
        }catch {
            NSLog("ForwardButton Touched Error", error.localizedDescription)
        }
    }
    
    func repeatTouched() {
        do {
            if self._startPosition != -1.0 && self._endPosition != -1.0 {
                try self.resetRepeat()
            }
            else if self._startPosition == -1.0 && self._endPosition == -1.0 {
                try self.setRepeatStart(position: self._currentTime)
            }
            else if self._startPosition != -1.0 && self._endPosition == -1.0 {
                try self.setRepeatEnd(position: self._currentTime)
            }
        }catch {
            NSLog("ForwardButton Touched Error", error.localizedDescription)
        }
    }
    
    func reducePlaybackRateTouched() {
        do {
            try self.decreasePlaybackRate()
        }catch {
            NSLog("ForwardButton Touched Error", error.localizedDescription)
        }
    }
    
    func increasePlaybackRateTouched() {
        do {
            try self.increasePlaybackRate()
        }catch {
            NSLog("ForwardButton Touched Error", error.localizedDescription)
        }
    }
    
    func muteTouched() {
        
    }
    
    func progressChanged(_ position: Float) {
        do {            
            try self.seek(position: TimeInterval(position))
        }catch {
            NSLog("ForwardButton Touched Error", error.localizedDescription)
        }
    }
    
    func volumeChanged(_ value: Float) {
    }
}
