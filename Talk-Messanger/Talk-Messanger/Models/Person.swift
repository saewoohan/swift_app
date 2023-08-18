//
//  Person.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/01/18.
//

import Foundation
import UIKit
import RealmSwift

class Person: Object {
    @objc dynamic var email: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var message: String?
    @objc dynamic var image: Data?
    @objc dynamic var backgroundImage: Data?
    var parentCategory = LinkingObjects(fromType: CurrentUser.self, property: "friends")
}
