//
//  Category.swift
//  PowerLIst
//
//  Created by Anthony Anisimov on 9/19/18.
//  Copyright © 2018 Anthony Anisimov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //defines forward relationship
    let items = List<Item>()
    
    
}
