//
//  AddContactViewController.swift
//  PhoneList
//
//  Created by Rob Napier on 5/1/19.
//  Copyright © 2019 Rob Napier. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!

    var completion: ((Contact) -> Void)?

    init(completion: ((Contact) -> Void)?) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    @IBAction func performDone(_ sender: Any) {
        self.completion?(Contact(displayName: nameField.text!,
                                phoneNumber: phoneField.text!))
        self.completion = nil
        presentingViewController?.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem = addButton
    }
}
