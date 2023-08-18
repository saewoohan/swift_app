//
//  Data.swift
//  Todoey
//
//  Created by 한승우 on 2022/12/31.
//

import Foundation
import RealmSwift

class Data: Object
{
    @objc dynamic var title: String = ""
    let items = List<Item>()
}
