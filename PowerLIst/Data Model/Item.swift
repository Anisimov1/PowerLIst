//
//  Item.swift
//  PowerLIst
//
//  Created by Anthony Anisimov on 9/19/18.
//  Copyright © 2018 Anthony Anisimov. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
