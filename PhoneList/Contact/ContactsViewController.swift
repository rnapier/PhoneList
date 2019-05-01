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

class ContactsViewController: ListViewController<Contact, AddContactViewController, ContactCell> {}
