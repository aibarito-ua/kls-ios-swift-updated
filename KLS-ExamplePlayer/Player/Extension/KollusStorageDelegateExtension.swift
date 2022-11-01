//
//  KollusStorageDelegateExtension.swift
//  KLS-ExamplePlayer
//
//  Created by HyeonDeok Yang on 2022/07/26.
//  Copyright © 2022 양현덕. All rights reserved.
//

import Foundation
extension ExamplePlayer: KollusStorageDelegate {

    
    func kollusStorage(_ kollusStorage: KollusStorage!, downloadContent content: KollusContent!, error: Error!) {
        NSLog("Contents 다운로드 중 %c , %f", content.mediaContentKey, content.downloadProgress)
    }
    
    func kollusStorage(_ kollusStorage: KollusStorage!, request: [AnyHashable : Any]!, json: [AnyHashable : Any]!, error: Error!) {
        if error != nil {
            NSLog("Callback  Error: %c", error.debugDescription)
        }
        else {
            do {
                NSLog("DRM Callback Request ")
                let requestData = try JSONSerialization.data(withJSONObject: request ?? nil, options: JSONSerialization.WritingOptions.prettyPrinted)
            
                NSLog("%c", String(data: requestData, encoding: String.Encoding.utf8) ?? "")
                NSLog("DRM Callback Response ")
                let responseData = try JSONSerialization.data(withJSONObject: json ?? nil, options: JSONSerialization.WritingOptions.prettyPrinted)
            
                NSLog("%c", String(data: responseData, encoding: String.Encoding.utf8) ?? "")
            }catch {
                NSLog("JSON PARSED Error")
            }
        }
    }
    
    func kollusStorage(_ kollusStorage: KollusStorage!, cur: Int32, count: Int32, error: Error!) {
        NSLog("Contents 갱신 중 %d / %d", cur, count)
    }
    
    func kollusStorage(_ kollusStorage: KollusStorage!, lmsData: String!, resultJson: [AnyHashable : Any]!) {
        NSLog("LMS Data 처리 : %c", lmsData)
    }
    
    func onSendCompleteStoredLms(_ successCount: Int32, failCount: Int32) {
        NSLog("미전송 LMS 처리 %d / %d", successCount, failCount)
    }
    
    
}
