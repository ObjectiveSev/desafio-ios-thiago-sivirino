//
//  NetworkService.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 24/07/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation

enum NetworkResult<T, NetworkError, Int> {
    case success(T, Int)
    case failure(NetworkError, Int)
}

enum NetworkError: Error {
    case undefined
    case withError(error: Error)
    case withDescription(description: String)
    
    func message() -> String {
        let undefined = "Algo de inesperado aconteceu e isso foi notificado!"
        switch self {
        case .undefined:
            return undefined
        case .withDescription(let description):
            return description
        case .withError(let error):
            return error.localizedDescription
        }
    }
    
    func code() -> Int {
        let undefined = -1
        switch self {
        case .withError(let error):
            return (error as NSError).code
        default:
            return undefined
        }
    }
    
}

enum NetworkResponse {
    case success(data: Data, code: Int)
    case failure(error: Error, code: Int)
}

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum Service: String {
    case marvelCharacter  = "/v1/public/characters"
}

struct NetworkService {
    
    var api: Service = .marvelCharacter
    var base: String = ""
    var path: String = ""
    var url: URL = URL(fileURLWithPath: "")
    var parameters: [String : Any]? = nil
    
    init(api: Service, path: String, parameters: [String : Any]? = nil) {
        switch api {
        case .marvelCharacter:
            self.base = Environment.getValue(forKey: .apiURL)
        }
        
        self.api = api
        self.path = path
        self.parameters = defaults(with: parameters)
        
        if let base = URL(string: self.base),
            let full = URL(string: String(base.appendingPathComponent(api.rawValue).appendingPathComponent(self.path).absoluteString.dropLast())) {
            self.url = full
        }
    }
    
    private func defaults(with parameters: [String : Any]? = nil) -> [String : Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyhhmmss"
        let timestamp = formatter.string(from: Date())
        let publicKey = Environment.getValue(forKey: .publicApiKey)
        let privateKey = Environment.getValue(forKey: .privateApiKey)
        let md5 = "\(timestamp)\(privateKey)\(publicKey)".MD5()
        
        var defaults: [String : Any] = [Constants.API.apiKey : publicKey,
                                        Constants.API.timestampKey : timestamp,
                                        Constants.API.hashKey : md5]
        
        parameters?.forEach {
            defaults.updateValue($0.value, forKey: $0.key)
        }
        
        return defaults
    }
}
