//
//  GLItemCell.swift
//  GroLis
//
//  Created by Miguel Grado on 6/15/17.
//  Copyright © 2017 Miguel Grado. All rights reserved.
//

import UIKit

class GLItemCell: UITableViewCell {

    @IBOutlet weak var mItemName: UILabel!
    @IBOutlet weak var mItemNotes: UILabel!
    @IBOutlet weak var mItemDone: UISwitch!
    
    var mListener: GLItemCellProtocol? = nil
    
    private var mItem: GLItemM? = nil
    var item: GLItemM {
        get {
            return mItem!
        }
        set {
            mItem = newValue

            if newValue.done {
                let attString = NSMutableAttributedString(string: newValue.name)
                attString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attString.length))
                mItemName.attributedText = attString
            } else {
                mItemName.text = newValue.name
            }
            
            mItemNotes.text = "Quantity \(newValue.quantity) \(newValue.notes.isEmpty ? "" : " | \(newValue.notes)")"
            
            mItemDone.isOn = newValue.done
        }
    }
    
    @IBAction func onCheckedChanged(_ sender: UISwitch) {
        mListener?.onDoneChanged(item: mItem!, done: sender.isOn)
    }
}
