//
//  PlayerControlDelegate.swift
//  KLS-ExamplePlayer
//
//  Created by HyeonDeok Yang on 2022/07/25.
//  Copyright © 2022 양현덕. All rights reserved.
//

import Foundation
protocol PlayerControlDelegate {
    func playTouched()
    func rewindTouched()
    func forwardTouched()
    func repeatTouched()
    func reducePlaybackRateTouched()
    func increasePlaybackRateTouched()
    func muteTouched()
    
    func progressChanged(_ position: Float)
    func volumeChanged(_ value: Float)
}
