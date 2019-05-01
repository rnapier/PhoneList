//
//  Generics.swift
//  PhoneList
//
//  Created by Rob Napier on 5/1/19.
//  Copyright © 2019 Rob Napier. All rights reserved.
//

import UIKit

protocol AdderType: UIViewController {
    associatedtype Element
    init(completion: ((Element) -> Void)?)
}

protocol CellType: UITableViewCell {
    associatedtype Element
    static func register(with: UITableView)
    static func dequeue(from: UITableView, for: IndexPath, with: Element) -> Self
}

class ListViewController<Element, AdderVC: AdderType, Cell: CellType>: UIViewController, UITableViewDataSource
    where AdderVC.Element == Element,
    Cell.Element == Element
{
    var elements: [Element] = []
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNew))
        navigationItem.rightBarButtonItem = addButton

        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        view.addSubview(tableView)

        Cell.register(with: tableView)
    }

    @objc func addNew() {
        let vc = AdderVC {
            self.elements.append($0)
            self.tableView.reloadData()
        }
        present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return Cell.dequeue(from: tableView, for: indexPath, with: elements[indexPath.row])
    }
}
