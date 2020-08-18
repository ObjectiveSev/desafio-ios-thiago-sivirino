//
//  APIResponse.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 18/08/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation
import ObjectMapper

class APIResponse<T: Mappable>: Mappable {
    var data: APIResult<T>?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.data <- map["data"]
    }
}

class APIResult<T: Mappable>: Mappable {
    var results: [T]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.results <- map["results"]
    }
}

class Thumbnail: Mappable {
    var path: String?
    var ext: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.path <- map["path"]
        self.ext <- map["extension"]
    }
    
    func fullPath() -> String? {
        "\(path ?? "").\(ext ?? "")"
    }
}

