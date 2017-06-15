//
// Created by Miguel Grado on 6/15/17.
// Copyright (c) 2017 Miguel Grado. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GLItemM {

    var uid: String = ""
    var name: String = ""
    var notes: String = ""
    var quantity: Int = 0
    var done: Bool = false

    init(snap: FIRDataSnapshot) {
        print(snap)

        let snapVal = snap.value as? NSDictionary

        self.uid = snap.key
        self.name = snapVal?["name"] as? String ?? ""
        self.notes = snapVal?["notes"] as? String ?? ""
        self.quantity = snapVal?["quantity"] as? Int ?? 0
        self.done = snapVal?["done"] as? Bool ?? false
    }
}
