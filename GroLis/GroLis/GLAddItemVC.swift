//
//  GLAddItemVC.swift
//  GroLis
//
//  Created by Miguel Grado on 6/15/17.
//  Copyright © 2017 Miguel Grado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GLAddItemVC: UIViewController {

    @IBOutlet weak var mItemName: UITextField!
    @IBOutlet weak var mItemNotes: UITextField!
    @IBOutlet weak var mItemQuantity: UITextField!

    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onAddClicked(_ sender: UIButton) {
        addItem(name: mItemName.text!, notes: mItemNotes.text!, quantity: Int(mItemQuantity.text!)!)
        dismiss()
    }

    @IBAction func onCancelClicked(_ sender: UIButton) {
        dismiss()
    }
}

extension GLAddItemVC: GLPresenterProtocol {

    func start() {
        ref = FIRDatabase.database().reference()
    }

    func stop() {
    }

    func addItem(name: String, notes: String, quantity: Int) {
        ref.child("items").childByAutoId().setValue([
                "done": false,
                "name": name,
                "notes": notes,
                "quantity": quantity
        ])
    }

    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}
