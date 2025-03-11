//
//  ContactHeaderCollectionView.swift
//  hw4
//
//  Created by Ani Lakirbaia on 03.02.25.
//

import Foundation
import UIKit

class ContactHeaderCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "ContactHeaderCollectionReusableView"
    
    private let headerView = ContactHeaderView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, section: Int, target: Any, action: Selector, isExpanded: Bool) {
        headerView.configure(with: title, section: section, target: target, action: action, isExpanded: isExpanded)
    }
}
