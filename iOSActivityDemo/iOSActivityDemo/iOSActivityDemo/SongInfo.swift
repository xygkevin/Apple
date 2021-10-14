//
//  SongInfo.swift
//  iOSActivityDemo
//
//  Created by uwei on 2018/8/6.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

import UIKit

class SongInfo: NSObject {
    var song: String
    var album: String
    var style: String
    
    init(song: String, album: String, style: String) {
        self.song = song
        self.album = album
        self.style = style
    }
}
