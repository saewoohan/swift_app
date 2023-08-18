//
//  Item.swift
//  Todoey
//
//  Created by 한승우 on 2023/01/02.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var check: Bool = false
}
