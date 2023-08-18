//
//  Chat.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/31.
//

import Foundation
import UIKit
import RealmSwift

class Chat: Object {
    @objc dynamic var sender: String = ""
    @objc dynamic var senderEmail: String = ""
    @objc dynamic var receiver: String = ""
    @objc dynamic var receiveEmail: String = ""
    @objc dynamic var message: String?
    @objc dynamic var image: Data?
    @objc dynamic var collection: String = ""
    @objc dynamic var date: Date?

    
    override static func primaryKey() -> String? {
        return "collection"
    }

}
