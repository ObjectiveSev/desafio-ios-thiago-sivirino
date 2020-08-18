//
//  ExpensiveComicViewModel.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 18/08/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation

protocol ExpensiveComicViewModelCoordinatorDelegate: class {
    func closeComic()
}

enum ExpensiveComicViewModelAction {
    case updateBindings, failure(error: Error, code: Int)
}

protocol ExpensiveComicViewModelDelegate: class {
    func didSelectAction(_ action: ExpensiveComicViewModelAction)
}

class ExpensiveComicViewModel {
    weak var coordinatorDelegate: ExpensiveComicViewModelCoordinatorDelegate?
    weak var delegate: ExpensiveComicViewModelDelegate?
    
    private let characterService: ICharactersService
    private let character: Character
    private(set) var comic: Comic?
    
    init(character: Character, characterService: ICharactersService) {
        self.character = character
        self.characterService = characterService
        getExpensiveComic()
    }
        
    func maxPrice(_ prices: [Price]?) -> Double {
        return prices?.map { $0.price ?? 0.0 }.max() ?? 0.0
    }
}

private extension ExpensiveComicViewModel {
    func getExpensiveComic() {
        characterService.getComics(id: character.id ?? 0) { response in
            switch response {
            case .failure(let error, let code):
                DispatchQueue.main.async {
                    self.delegate?.didSelectAction(.failure(error: error, code: code))
                }
            case .success(let result, _):
                guard let comics = result.data?.results, !comics.isEmpty else {
                    self.handleError()
                    return
                }
                let expensive = comics.max { first, second -> Bool in
                    self.maxPrice(first.prices) < self.maxPrice(second.prices)
                }
                self.comic = expensive
                DispatchQueue.main.async {
                    self.delegate?.didSelectAction(.updateBindings)
                }
            }
        }
    }
    
    func handleError() {
        DispatchQueue.main.async {
            self.delegate?.didSelectAction(.failure(error: NSError.from(code: -1, data: Data(), description: "Não foram achadas revistas"), code: -1))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.coordinatorDelegate?.closeComic()
            }
        }
    }
}
