//
//  HotelsService.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 24/07/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation
import PromiseKit

protocol ICharactersService {
    typealias CharactersHandler = (NetworkResult<APIResponse<Character>, NetworkError, Int>) -> Void
    typealias ComicsHandler = (NetworkResult<APIResponse<Comic>, NetworkError, Int>) -> Void
    
    func getCharacters(offset: Int, handler: @escaping CharactersHandler)
    func getComics(id: Int, handler: @escaping ComicsHandler)
}

class CharactersService: NetworkBaseService, ICharactersService {
    func getCharacters(offset: Int, handler: @escaping CharactersHandler) {
        let path = ""
        let parameters: [String: Any] = ["limit" : 20,
                                         "offset" : offset]
        let service = NetworkService(api: .marvelCharacter, path: path, parameters: parameters)
        NetworkDispatch.shared.get(service, handler: handler)
    }
    
    func getComics(id: Int, handler: @escaping ComicsHandler) {
        let path = "\(id)/comics/"
        let parameters: [String: Any] = [:]
        let service = NetworkService(api: .marvelCharacter, path: path, parameters: parameters)
        NetworkDispatch.shared.get(service, handler: handler)
    }
}
