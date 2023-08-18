//
//  Message.swift
//  FlashChat
//
//  Created by 한승우 on 2022/12/30.
//

import Foundation


struct Message {
    var sender: String = "hso2341@naver.com"
    var body: String = "1234"
    
    init(sender: String, body: String) {
        self.sender = sender
        self.body = body
    }
}
