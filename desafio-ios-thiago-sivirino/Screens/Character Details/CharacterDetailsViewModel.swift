//
//  CharacterDetailsViewModel.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 18/08/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation

protocol CharacterDetailsViewModelCoordinatorDelegate: class {
    func closeDetails()
    func seeComic(_ character: Character)
}

class CharacterDetailsViewModel {
    weak var coordinatorDelegate: CharacterDetailsViewModelCoordinatorDelegate?
    
    let character: Character
    
    init(character: Character) {
        self.character = character
    }
}
