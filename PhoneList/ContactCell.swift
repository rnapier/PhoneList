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
        tableView.register(UINib(nibName: ContactCell.identifier, bundle: nil), forCellReuseIdentifier: ContactCell.identifier)
    }

    static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with contact: Contact) -> ContactCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as! ContactCell
        cell.contact = contact
        return cell
    }

    @IBOutlet weak var nameField: UILabel!

    var contact: Contact? {
        didSet { nameField.text = contact?.displayName }
    }

    override func prepareForReuse() { contact = nil }

}
