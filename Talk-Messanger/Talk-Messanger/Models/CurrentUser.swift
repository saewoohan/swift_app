//
//  CurrentUser.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/26.
//

import Foundation
import UIKit
import RealmSwift

class CurrentUser: Object {
    @objc dynamic var email: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var message: String?
    @objc dynamic var image: Data?
    @objc dynamic var backgroundImage: Data?
    let friends = List<Person>()
    
    override static func primaryKey() -> String? {
        return "email"
    }
    

}
