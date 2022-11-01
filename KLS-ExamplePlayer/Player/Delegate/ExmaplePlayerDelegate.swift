//
//  ExmaplePlayerProtocol.swift
//  kls-ios-swift
//
//  Created by HyeonDeok Yang on 2022/07/20.
//  Copyright © 2022 양현덕. All rights reserved.
//

import Foundation

protocol ExamplePlayerDelegate {
    func prepared()
    func paused()
    func progress(_ progress:TimeInterval)
    func playbackrate(_ playbackrate:Float)
    func error(error: Error)
    
}
