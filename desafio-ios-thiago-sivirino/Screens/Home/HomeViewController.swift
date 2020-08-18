//
//  HomeViewController.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 23/07/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    let viewModel: HomeViewModel
    
    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.configure(type: .searchInitial)
        return view
    }()
    
     private lazy var collectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
           collection.delegate = self
           collection.dataSource = self
           let refreshControl = UIRefreshControl()
           refreshControl.tintColor = .primaryColor
           refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
           collection.refreshControl = refreshControl
           collection.backgroundColor = .white
           collection.registerCell(cellClass: HomeCharacterCell.self)
           return collection
       }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
        viewModel.delegate = self
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getItems(reload: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeViewController {
    func configureLayout() {
        view.backgroundColor = .white
        navigationItem.title = "Marvel Characters"
        
        collectionView.createConstraints(view) { maker in
            maker.edges.equalToSuperview()
        }
        
        emptyView.createConstraints(view) { maker in
            maker.center.equalToSuperview()
        }
    }
    
    @objc func didRefresh() {
        viewModel.getItems(reload: true)
    }
    
    func showNoResults() {
        emptyView.configure(type: .search)
        emptyView.isHidden = false
        collectionView.isHidden = true
    }
    
    func prepareShowResults() {
        emptyView.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didSelectAction(_ action: HomeViewModelAction) {
        collectionView.endRefreshing()
        switch action {
        case .empty:
            showNoResults()
        case .reload:
            prepareShowResults()
        case .failure(let error, let code):
            if code != HAError.invalidQuery.code {
                showError(error: error)
            }
        }
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRowsIn(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellClass: HomeCharacterCell.self, indexPath: indexPath)
        let (image, name) = viewModel.itemAt(indexPath)
        cell.configure(image: image, name: name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.handleDisplayItemAt(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: select
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 2
        return CGSize(width: cellWidth, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
}
