//
//  UICollectionViewCell.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 17/08/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    /** Return identifier with the same name of the subclass */
    static var defaultIdentifier: String {
        return String(describing: self)
    }
}
