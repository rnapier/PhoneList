//
//  ContactCell.swift
//  PhoneList
//
//  Created by Rob Napier on 5/1/19.
//  Copyright © 2019 Rob Napier. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    static let identifier = "ContactCell"

    static func register(with tableView: UITableView) {
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
    }

    static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with contact: Contact) -> ContactCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as! ContactCell
        cell.contact = contact
        return cell
    }

    var contact: Contact? {
        didSet { textLabel?.text = contact?.displayName }
    }

    override func prepareForReuse() {
        contact = nil
    }

}
