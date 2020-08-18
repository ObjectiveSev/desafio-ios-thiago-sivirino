//
//  HomeViewModel.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 23/07/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import Foundation

enum HomeViewModelAction {
    case reload, failure(error: Error, code: Int), empty
}

protocol HomeViewModelDelegate: class {
    func didSelectAction(_ action: HomeViewModelAction)
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    
    private let charactersService: ICharactersService
    private var endOfPage = false
    private var isLoading = false
    
    private var characters = [Character]()
    
    init(hotelsService: ICharactersService) {
        self.charactersService = hotelsService
    }
    
    func getItems(reload: Bool) {
        loadItems(reload: reload)
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRowsIn(_ section: Int) -> Int {
        characters.count
    }
    
    func itemAt(_ indexPath: IndexPath) -> (image: String?, name: String?) {
        let char = characters[indexPath.row]
        return ("\(char.thumbnail?.path ?? "").\(char.thumbnail?.ext ?? "")", char.name)
    }
    
    func handleDisplayItemAt(_ indexPath: IndexPath) {
        if indexPath.row >= characters.count - 5 {
            getItems(reload: false)
        }
    }
}

private extension HomeViewModel {
    func loadItems(reload: Bool) {
        if reload {
            endOfPage = false
            characters = []
        }
        guard !endOfPage, !isLoading else {
            let error = HAError.invalidQuery
            delegate?.didSelectAction(.failure(error: error, code: error.code))
            return
        }
        
        isLoading = true
        charactersService.getCharacters(offset: characters.count) { result in
            self.isLoading = false
            switch result {
            case .failure(let error, let code):
                DispatchQueue.main.async {
                    self.delegate?.didSelectAction(.failure(error: error, code: code))
                }
            case .success(let result, _):
                if let chars = result.data?.results {
                    if chars.isEmpty {
                        if reload {
                            DispatchQueue.main.async {
                                self.delegate?.didSelectAction(.empty)
                            }
                        } else {
                            self.endOfPage = true
                        }
                    } else {
                        self.endOfPage = false
                        self.characters.append(contentsOf: chars)
                        DispatchQueue.main.async {
                            self.delegate?.didSelectAction(.reload)
                        }
                    }
                }
            }
        }
    }
    
}
