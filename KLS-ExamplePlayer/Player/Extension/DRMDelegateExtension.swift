//
//  DRMDelegateExtension.swift
//  kls-ios-swift
//
//  Created by HyeonDeok Yang on 2022/07/20.
//  Copyright © 2022 양현덕. All rights reserved.
//

import Foundation

extension ExamplePlayer : KollusPlayerDRMDelegate {
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, request: [AnyHashable : Any]!, json: [AnyHashable : Any]!, error: Error!) {
    }
}
