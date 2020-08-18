//
//  Characters.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 24/07/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation
import ObjectMapper

class Character: Mappable {
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: Thumbnail?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.thumbnail <- map["thumbnail"]
        self.description <- map["description"]
    }
}
