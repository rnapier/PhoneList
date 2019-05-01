//
//  ContactsViewController.swift
//  PhoneList
//
//  Created by Rob Napier on 5/1/19.
//  Copyright © 2019 Rob Napier. All rights reserved.
//

import UIKit

extension AddContactViewController: AdderType {}
extension ContactCell: CellType {}

// Subclassing is required here for storyboards. If this were programmatic, it could be a typealias.
class ContactsViewController: ListViewController<StaticDataStore<Contact>, AddContactViewController, ContactCell> {}
