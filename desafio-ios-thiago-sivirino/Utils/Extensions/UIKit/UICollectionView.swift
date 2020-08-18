//
//  UICollectionView.swift
//  desafio-ios-thiago-sivirino
//
//  Created by Thiago Augusto on 17/08/20.
//  Copyright © 2020 objectivesev. All rights reserved.
//

import UIKit

extension UICollectionView {
    /** Shortcut: Register a cell with his Default name and identifier on the main bundle. */
    func registerCell<T: UICollectionViewCell>(cellClass: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.defaultIdentifier)
    }
    
    /** Shortcut: Dequeue a cell with his default Class Name. Example: MyCustomCell.self */
    func dequeue<T: UICollectionViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T {
        return self.dequeue(withIdentifier: cellClass.defaultIdentifier, indexPath: indexPath)
    }
    
    /** Dequeue a cell with automatic casting */
    private func dequeue<T: UICollectionViewCell>(withIdentifier id: String, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! T
    }
    
    func beginRefreshing() {
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else {
            return
        }
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
        
        let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        setContentOffset(contentOffset, animated: true)
    }
    
    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
}
