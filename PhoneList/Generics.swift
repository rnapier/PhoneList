//
//  Generics.swift
//  PhoneList
//
//  Created by Rob Napier on 5/1/19.
//  Copyright © 2019 Rob Napier. All rights reserved.
//

import UIKit

// A generic stack including:
//   * ListViewController: Lists a bunch of things in cells, and lets you add new ones with some "adder"
//   * Adder: A view controller that can gather info for Element
//   * CellType: A cell that can show info for element

struct DataStore<Element> {
    var elements: [Element] = []
}

protocol AdderType: UIViewController {
    associatedtype Element
    init(completion: ((Element) -> Void)?)
}

protocol CellType: UITableViewCell {
    associatedtype Element
    static func register(with: UITableView)
    static func dequeue(from: UITableView, for: IndexPath, with: Element) -> Self
}

class ListViewController<AdderVC: AdderType, Cell: CellType>: UIViewController, UITableViewDataSource
    where AdderVC.Element ==  Cell.Element
{
    typealias Element = AdderVC.Element
    var dataStore = DataStore<Element>()
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
            self.dataStore.elements.append($0)
            self.tableView.reloadData()
        }
        present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return Cell.dequeue(from: tableView, for: indexPath, with: dataStore.elements[indexPath.row])
    }
}
