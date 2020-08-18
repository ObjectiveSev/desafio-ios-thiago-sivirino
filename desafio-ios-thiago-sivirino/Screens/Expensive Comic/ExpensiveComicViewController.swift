//
//  ExpensiveComicViewController.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 18/08/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import UIKit

class ExpensiveComicViewController: BaseViewController {
    let viewModel: ExpensiveComicViewModel
    
    private lazy var comicImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 3
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    init(viewModel: ExpensiveComicViewModel) {
        self.viewModel = viewModel
        super.init()
        viewModel.delegate = self
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ExpensiveComicViewController {
    func configureLayout() {
        navigationItem.title = "Expensive comic"
        
        scrollView.createConstraints(view) { maker in
            maker.edges.equalToSuperview()
        }
        
        titleLabel.createConstraints(scrollView) { maker in
            maker.top.equalToSuperview().inset(10)
            maker.leading.trailing.equalToSuperview().inset(5)
        }
        
        comicImage.createConstraints(scrollView) { maker in
            maker.leading.trailing.equalTo(titleLabel)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.width.equalToSuperview().offset(-10)
        }
        
        descriptionLabel.createConstraints(scrollView) { maker in
            maker.leading.trailing.equalTo(titleLabel)
            maker.top.equalTo(comicImage.snp.bottom).offset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func updateBindings() {
        let price = viewModel.maxPrice(viewModel.comic?.prices)
        let title = viewModel.comic?.title ?? ""
        titleLabel.text = "$\(price) \(title)"
        descriptionLabel.text = viewModel.comic?.description
        comicImage.loadWith(viewModel.comic?.thumbnail?.fullPath())
    }
}

extension ExpensiveComicViewController: ExpensiveComicViewModelDelegate {
    func didSelectAction(_ action: ExpensiveComicViewModelAction) {
        switch action {
        case .failure(let error, _):
            showError(error: error)
        case .updateBindings:
            updateBindings()
        }
    }
}
