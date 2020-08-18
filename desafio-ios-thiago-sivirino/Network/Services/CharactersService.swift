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
    typealias CharactersHandler = (NetworkResult<CharactersResponse, NetworkError, Int>) -> Void
    
    func getCharacters(offset: Int, handler: @escaping CharactersHandler)
}

class CharactersService: NetworkBaseService, ICharactersService {
    func getCharacters(offset: Int, handler: @escaping CharactersHandler) {
        let path = ""
        let parameters: [String: Any] = ["limit" : 20,
                                         "offset" : offset]
        let service = NetworkService(api: .marvelCharacter, path: path, parameters: parameters)
        NetworkDispatch.shared.get(service, handler: handler)
    }
}
