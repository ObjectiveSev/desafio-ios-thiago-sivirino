//
//  Environment.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 23/07/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation

extension Environment {
    enum Variable: String {
        case apiURL = "API_URL"
        case publicApiKey = "PUBLIC_API_KEY"
        case privateApiKey = "PRIVATE_API_KEY"
    }
}

struct Environment {
    static func getValue(forKey key: Variable) -> String {
        return infoForKey(key.rawValue)
    }
    
    private static func infoForKey(_ key: String) -> String {
        guard let value = (Bundle.main.infoDictionary?[key] as? String) else {
            fatalError("Could not get value for key: \(key)")
        }
        return value.replacingOccurrences(of: "\\", with: "")
    }
}
