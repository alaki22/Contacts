//
//  ContactHeaderView.swift
//  hw4
//
//  Created by Ani Lakirbaia on 03.02.25.
//

import Foundation
import UIKit

class ContactHeaderView: UIView {
    static let reuseIdentifier = "ContactHeaderView"

    private let label = UILabel()
    private let button = UIButton()

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

       
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),

            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 80),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, section: Int, target: Any, action: Selector, isExpanded: Bool) {
        label.text = title
        button.setTitle(isExpanded ? "Collapse" : "Expand", for: .normal)
        button.tag = section
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}
