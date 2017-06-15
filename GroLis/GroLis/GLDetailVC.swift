//
//  GLDetailVC.swift
//  GroLis
//
//  Created by Miguel Grado on 6/15/17.
//  Copyright © 2017 Miguel Grado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GLDetailVC: UIViewController {

    @IBOutlet weak var mNavBar: UINavigationItem!
    @IBOutlet weak var mDoneButton: UIBarButtonItem!
    @IBOutlet weak var mItemImage: UIImageView!
    @IBOutlet weak var mItemName: UILabel!
    @IBOutlet weak var mItemNotes: UILabel!
    @IBOutlet weak var mItemQuantity: UILabel!

    var mItem: GLItemM? = nil
    var itemId: String = ""
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUi() {
        mNavBar.title = mItem?.name
        
        mDoneButton.isEnabled = !(mItem?.done)!
        
        mItemName.text = mItem?.name
        
        mItemNotes.text = mItem?.notes
        
        mItemQuantity.text = "\(mItem?.quantity ?? 0)"
    }
    
    @IBAction func onDoneClicked(_ sender: Any) {
        checkItemDone(checked: true)
    }
}

extension GLDetailVC: GLPresenterProtocol {

    func start() {
        ref = FIRDatabase.database().reference()
        ref.child("items").child(itemId).observe(FIRDataEventType.value, with: { snap in
            self.mItem = GLItemM(snap: snap)

            self.updateUi()
        })
    }

    func stop() {}

    func checkItemDone(checked: Bool) {
        let childUpdate = ["/done": checked]

        ref.child("items").child((mItem?.uid)!).updateChildValues(childUpdate)
    }
}
