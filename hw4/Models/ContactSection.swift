//
//  ContactSection.swift
//  hw4
//
//  Created by Ani Lakirbaia on 02.02.25.
//

import Foundation
import UIKit

final class ContactSection{
    var title: String
    var contacts: [Contact]
    var isExpanded: Bool

    init(title: String, contacts: [Contact]) {
        self.title = title
        self.contacts = contacts
        self.isExpanded = true
    }
}



