//
//  CharacterDetailsViewController.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 18/08/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: BaseViewController {
    let viewModel: CharacterDetailsViewModel
    
    private lazy var characterImage: UIImageView = {
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
    
    private lazy var comicsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Expensive Comic", style: .done, target: self, action: #selector(comicsTapped))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        return button
    }()
    
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)ç
        return button
    }()
    
    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init()
        configureLayout()
        configureView()
        configureNavBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CharacterDetailsViewController {
    @objc func comicsTapped() {
        viewModel.coordinatorDelegate?.seeComic()
    }
    
    @objc func closeTapped() {
        viewModel.coordinatorDelegate?.closeDetails()
    }
    
    func configureLayout() {
        scrollView.createConstraints(view) { maker in
            maker.edges.equalToSuperview()
        }
        
        titleLabel.createConstraints(scrollView) { maker in
            maker.top.equalToSuperview().inset(10)
            maker.leading.trailing.equalToSuperview().inset(5)
        }
        
        characterImage.createConstraints(scrollView) { maker in
            maker.leading.trailing.equalTo(titleLabel)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.width.equalToSuperview().offset(-10)
        }
        
        descriptionLabel.createConstraints(scrollView) { maker in
            maker.leading.trailing.equalTo(titleLabel)
            maker.top.equalTo(characterImage.snp.bottom).offset(10)
            maker.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configureNavBar() {
        navigationItem.title = "Details"
        navigationItem.leftBarButtonItem = comicsButton
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func configureView() {
        titleLabel.text = viewModel.character.name
        descriptionLabel.text = viewModel.character.description
        characterImage.loadWith(viewModel.character.thumbnail?.fullPath())
    }
}
