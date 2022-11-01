//
//  DRMDelegateExtension.swift
//  kls-ios-swift
//
//  Created by HyeonDeok Yang on 2022/07/20.
//  Copyright © 2022 양현덕. All rights reserved.
//

import Foundation

//MARK: Kollus DRM Callback Extension
extension ExamplePlayer : KollusPlayerDRMDelegate {
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, request: [AnyHashable : Any]!, json: [AnyHashable : Any]!, error: Error!) {
        
        if error != nil {
            NSLog("Callback  Error: %c", error.debugDescription)
        }
        else {
            
            do {
                NSLog("Callback Request ")
                let requestData = try JSONSerialization.data(withJSONObject: request ?? nil, options: JSONSerialization.WritingOptions.prettyPrinted)
            
                NSLog("%c", String(data: requestData, encoding: String.Encoding.utf8) ?? "")
                NSLog("Callback Response ")
                let responseData = try JSONSerialization.data(withJSONObject: json ?? nil, options: JSONSerialization.WritingOptions.prettyPrinted)
            
                NSLog("%c", String(data: responseData, encoding: String.Encoding.utf8) ?? "")
            }catch {
                NSLog("JSON PARSED Error")
            }
        }
    }
}
