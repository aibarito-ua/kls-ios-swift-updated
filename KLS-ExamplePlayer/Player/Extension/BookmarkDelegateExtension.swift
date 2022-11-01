//
//  BookmarkDelegateExtension.swift
//  kls-ios-swift
//
//  Created by HyeonDeok Yang on 2022/07/20.
//  Copyright © 2022 양현덕. All rights reserved.
//

import Foundation

extension ExamplePlayer: KollusPlayerBookmarkDelegate {
    func kollusPlayerView(_ kollusPlayerView: KollusPlayerView!, bookmark bookmarks: [Any]!, enabled: Bool, error: Error!) {
        if error != nil {
            NSLog("Bookmark Load Error: %c", error.debugDescription)
        }
        else {
            
            NSLog("Bookmark : %c", String(enabled))
            for bk in bookmarks {
                let b = bk as! KollusBookmark
                if b.kind == .index {
                    NSLog("Bookmark Item : %c/%f", b.title, b.position)
                }
                else {
                    NSLog("Bookmark Item : %c/%f", b.value, b.position)
                }
            }
        }
    }
}
