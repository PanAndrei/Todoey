//
//  DataModel.swift
//  Todoey
//
//  Created by Andrei Panasenko on 03.02.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

class DataModel: Encodable {
    var title: String = ""
    var checked: Bool = false
}
