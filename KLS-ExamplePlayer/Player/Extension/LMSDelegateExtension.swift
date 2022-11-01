//
//  LMSDelegateExtension.swift
//  kls-ios-swift
//
//  Created by HyeonDeok Yang on 2022/07/20.
//  Copyright © 2022 양현덕. All rights reserved.
//

import Foundation

extension ExamplePlayer: KollusPlayerLMSDelegate {
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, json: [AnyHashable : Any]!, error: Error!) {
        if error != nil {
            NSLog("LMS Callback  Error: %c", error.debugDescription)
        }
        else {
            
            do {
                NSLog("LMS Callback Send ")
                let responseData = try JSONSerialization.data(withJSONObject: json ?? nil, options: JSONSerialization.WritingOptions.prettyPrinted)
            
                NSLog("%c", String(data: responseData, encoding: String.Encoding.utf8) ?? "")
            }catch {
                NSLog("JSON PARSED Error")
            }
        }
    }
}
