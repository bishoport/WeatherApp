//
//  FavoriteCity.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 26/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit

class FavoriteCity: NSObject, NSCoding {

    let name: String
    let id : String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.id = decoder.decodeObject(forKey: "id") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(id, forKey: "id")
    }
}
