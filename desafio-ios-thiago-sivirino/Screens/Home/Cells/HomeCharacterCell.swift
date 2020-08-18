//
//  HomeHotelCell.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 28/07/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//


import UIKit
import SDWebImage

class HomeCharacterCell: UICollectionViewCell {
    
    private lazy var resultImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resultImage.image = nil
    }
    
    func configure(image: String?, name: String?) {
        resultImage.loadWith(image)
        titleLabel.text = name
    }
}

private extension HomeCharacterCell {
    func configureLayout() {
        titleLabel.createConstraints(contentView) { maker in
            maker.leading.bottom.trailing.equalToSuperview().inset(6)
        }
        
        resultImage.createConstraints(contentView) { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(titleLabel.snp.top).offset(-6)
        }
    }
}
