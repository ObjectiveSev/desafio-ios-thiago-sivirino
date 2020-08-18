//
//  HomeViewModelTest.swift
//  desafio-ios-thiago-sivirinoTests
//
//  Created by Thiago Augusto on 30/07/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import XCTest
@testable import desafio_ios_thiago_sivirino

class HomeViewModelTest: XCTestCase {
    class MockCharactersService: ICharactersService {
        var characters = [Character]()
        var isSuccess = true
        var errorCode = 0
        
        func getCharacters(offset: Int, handler: @escaping CharactersHandler) {
            let data = CharacterResult(JSON: [:])!
            data.results = characters
            let result = CharactersResponse(JSON: [:])!
            result.data = data
            let error = NetworkError.withError(error: NSError.from(code: errorCode, data: Data(), description: ""))
            handler(isSuccess ? .success(result, 200) : .failure(error, errorCode))
        }
    }
    
    private var mockService: MockCharactersService!
    private var viewModel: HomeViewModel!
    private var delegateExpectation: XCTestExpectation!
    private var actionResult: HomeViewModelAction!
    
    override func setUp() {
        mockService = MockCharactersService()
        viewModel = HomeViewModel(hotelsService: mockService)
        viewModel.delegate = self
    }
    
    override func tearDown() {
        mockService = nil
        viewModel = nil
        delegateExpectation = nil
        actionResult = nil
    }
    
    // MARK: Initial Values
    func testInit_Empty() {
        XCTAssertEqual(1, viewModel.numberOfSections())
        XCTAssertEqual(0, viewModel.numberOfRowsIn(0))
    }
    
    // MARK: Error
    func testError_delegatesError() {
        createExpectation()
        
        mockService.isSuccess = false
        mockService.errorCode = 404
        viewModel.getItems(reload: true)
        
        wait(for: [delegateExpectation], timeout: 20)
        switch actionResult {
        case .failure(_, let code):
            XCTAssertEqual(code, 404)
        default:
            XCTFail()
        }
    }
    
    // MARK: Results
    func testResult_hasItems() {
        createExpectation()
        
        let results = Character(JSON: ["name": "first"])!
        mockService.characters = [results]
        
        viewModel.getItems(reload: true)
        
        wait(for: [delegateExpectation], timeout: 20)
        XCTAssertEqual(viewModel.numberOfSections(), 1)
        XCTAssertEqual(viewModel.numberOfRowsIn(0), 1)
        let viewModelItem = viewModel.itemAt(IndexPath(row: 0, section: 0))
        XCTAssertEqual(viewModelItem.name, "first")
    }
    
    
    func testResult_pagination() {
        
        let first = Character(JSON: ["name": "first"])!
        let second = Character(JSON: ["name": "second"])!
        let third = Character(JSON: ["name": "third"])!
        
        mockService.characters = [first, second, third]
        
        viewModel.getItems(reload: true)
        
        let firstLater = Character(JSON: ["name": "firstLater"])!
        let secondLater = Character(JSON: ["name": "secondLater"])!
        
        // Create an expectation
        let expectation = self.expectation(description: "MainQueueDispatch")
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        createExpectation()
        
        mockService.characters = [firstLater, secondLater]
        viewModel.getItems(reload: false)
        
        wait(for: [delegateExpectation], timeout: 20)
        XCTAssertEqual(viewModel.numberOfSections(), 1)
        XCTAssertEqual(viewModel.numberOfRowsIn(0), 5)
        XCTAssertEqual(viewModel.itemAt(IndexPath(row: 0, section: 0)).name, "first")
        XCTAssertEqual(viewModel.itemAt(IndexPath(row: 1, section: 1)).name, "second")
        XCTAssertEqual(viewModel.itemAt(IndexPath(row: 2, section: 2)).name, "third")
        XCTAssertEqual(viewModel.itemAt(IndexPath(row: 3, section: 2)).name, "firstLater")
        XCTAssertEqual(viewModel.itemAt(IndexPath(row: 4, section: 2)).name, "secondLater")
    }
}

// MARK: Helpers
private extension HomeViewModelTest {
    // Não dá pra colocar no setUp pois nem todos os métodos de teste usam a expectation.
    // Logo eles iriam acabar falhando sem precisar
    func createExpectation() {
        delegateExpectation = expectation(description: "HomeViewModel")
    }
}

extension HomeViewModelTest: HomeViewModelDelegate {
    func didSelectAction(_ action: HomeViewModelAction) {
        actionResult = action
        delegateExpectation?.fulfill()
    }
}
