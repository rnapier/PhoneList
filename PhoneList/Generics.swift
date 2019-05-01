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
//   * DataStore: a generic way to store elements and return animation-driving changes.

// A change to the datastore that you may want to animate
enum DataStoreChange {
    case insert(Int)
    // TODO: delete and move operations
}

// Animations for table views
extension Array where Element == DataStoreChange {
    func apply(to tableView: UITableView) {
        for change in self {
            switch change {
            case .insert(let row):
                tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            }
        }
    }
}

// An arbitary storage for elements. Could be Core Data. Could be UserDefaults. Could be static.
protocol DataStoreType: Collection where Index == Int {
    init() // this is because of Storyboards. I don't like it. Programmatically, it wouldn't be needed because it could be configurated in the view controller init().
    mutating func insert(_ element: Element) -> [DataStoreChange]
}

// A static implementation of DataStore.
struct StaticDataStore<Element>: DataStoreType {
    private var elements: [Element] = []

    // Don't allow aribitrary insert points. This is up to the data store (it might be sorted)
    mutating func insert(_ element: Element) -> [DataStoreChange]{
        let row = elements.count
        elements.append(element)
        return [.insert(row)]
    }
}

extension StaticDataStore: Collection {
    var startIndex: Int { return elements.startIndex }
    var endIndex: Int { return elements.endIndex }
    func index(after i: Int) -> Int {
        return elements.index(after: i)
    }
    subscript(_ i: Int) -> Element {
        return elements[i]
    }
}

// Something that can add a new element.
protocol AdderType: UIViewController {
    associatedtype Element
    init(completion: ((Element) -> Void)?)
}

// A cell to display an element
protocol CellType: UITableViewCell {
    associatedtype Element
    static func register(with: UITableView)
    static func dequeue(from: UITableView, for: IndexPath, with: Element) -> Self
}

// Generic list controller that shows a list of things and lets you add them.
// This has a lot of interesting trade-offs. All the concrete types are nailed down at compile-time. That makes
// them very clear, but also means they can't be modified at runtime. It's conceivable that you'd want the
// DataStore to change at runtime (though I would lean towards doing that with composition rather than protocols).
// There are a lot of type parameters here, which is not great (especially since type parameters can't have defaults
// and don't have labels). If it weren't for storyboards, we could make some of the ergonomics better there. Even
// so, one could imagine GETs making this a little less wordy (though I think you'd have to actually try it to see
// if that's true).
class ListViewController<DataStore: DataStoreType, AdderVC: AdderType, Cell: CellType>: UIViewController, UITableViewDataSource
    where AdderVC.Element ==  Cell.Element,
    AdderVC.Element == DataStore.Element
{
    typealias Element = AdderVC.Element
    var dataStore = DataStore() // I don't like this. It's because of storyboards.
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
        let vc = AdderVC { self.dataStore.insert($0).apply(to: self.tableView) }
        present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return Cell.dequeue(from: tableView, for: indexPath, with: dataStore[indexPath.row])
    }
}
