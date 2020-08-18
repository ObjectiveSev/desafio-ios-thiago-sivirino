//
//  Comic.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 18/08/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation
import ObjectMapper

class Comic: Mappable {
    var title: String?
    var description: String?
    var thumbnail: Thumbnail?
    var prices: [Price]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        thumbnail <- map["thumbnail"]
        prices <- map["prices"]
    }
}

class Price: Mappable {
    var price: Double?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        price <- map["price"]
    }
}
