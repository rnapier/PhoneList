//
//  ContactsViewController.swift
//  PhoneList
//
//  Created by Rob Napier on 5/1/19.
//  Copyright © 2019 Rob Napier. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource {
    var contacts: [Contact] = []
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContact))
        navigationItem.rightBarButtonItem = addButton

        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        view.addSubview(tableView)

        ContactCell.register(with: tableView)
    }

    @objc func addNewContact() {
        let vc = AddContactViewController {
            self.contacts.append($0)
            self.tableView.reloadData()
        }
        present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ContactCell.dequeue(from: tableView, for: indexPath, with: contacts[indexPath.row])
    }

}

