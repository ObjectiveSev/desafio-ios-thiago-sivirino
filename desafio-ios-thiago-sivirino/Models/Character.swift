//
//  Characters.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 24/07/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation
import ObjectMapper

class CharactersResponse: Mappable {
    var data: CharacterResult?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.data <- map["data"]
    }
}

class CharacterResult: Mappable {
    var results: [Character]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.results <- map["results"]
    }
}

class Character: Mappable {
    var id: Int?
    var name: String?
    var thumbnail: CharacterThumbnail?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.thumbnail <- map["thumbnail"]
    }
}

class CharacterThumbnail: Mappable {
    var path: String?
    var ext: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.path <- map["path"]
        self.ext <- map["extension"]
    }
}

