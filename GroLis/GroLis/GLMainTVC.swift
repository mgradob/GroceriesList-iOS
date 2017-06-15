//
//  GLMainTVC.swift
//  GroLis
//
//  Created by Miguel Grado on 6/8/17.
//  Copyright © 2017 Miguel Grado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GLMainTVC: UITableViewController {

    var mItems = [GLItemM]()
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return hasHeaders() ? 2 : 1
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if hasHeaders() {
            if section == 0 {
                return "New"
            } else if section == 1 {
                return "Completed"
            }
        }

        return super.tableView(tableView, titleForHeaderInSection: section)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasHeaders() {
            if section == 0 {
                return getUndoneItemsCount()
            } else if section == 1 {
                return getDoneItemsCount()
            }
        }

        return mItems.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = 0

        if hasHeaders() {
            if indexPath.section == 0 {
                index = indexPath.row
            } else if indexPath.section == 1 {
                index = getDoneItemsStart() + indexPath.row
            }
        } else {
            index = indexPath.row
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "GLItemCell", for: indexPath) as! GLItemCell

        cell.mListener = self

        cell.item = mItems[index]

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is GLDetailVC:
            let cell = sender as! GLItemCell

            let destinationVC: GLDetailVC = segue.destination as! GLDetailVC
            destinationVC.itemId = cell.item.uid
            break
        default: break
        }
    }

}

extension GLMainTVC {

    func updateUi() {
        self.tableView.reloadData()
    }

    func hasHeaders() -> Bool {
        if (mItems.count < 2) {
            return false
        }

        var hasUndone = false
        for item in mItems {
            if (!item.done) {
                hasUndone = true
                break
            }
        }

        var hasDone = false
        for item in mItems {
            if (item.done) {
                hasDone = true
                break
            }
        }

        return hasUndone && hasDone
    }

    func getUndoneItemsCount() -> Int {
        var count = 0

        for item in mItems {
            if item.done {
                break
            }

            count += 1
        }

        return count
    }

    func getDoneItemsCount() -> Int {
        var index = getDoneItemsStart()
        var count = 0

        while (index < mItems.count) {
            index += 1
            count += 1
        }

        return count
    }

    func getDoneItemsStart() -> Int {
        for (index, item) in mItems.enumerated() {
            if item.done {
                return index
            }
        }

        return mItems.count > 0 ? mItems.count + 1 : 1
    }
}

extension GLMainTVC: GLPresenterProtocol, GLItemCellProtocol {

    func start() {
        ref = FIRDatabase.database().reference()
        ref.child("items").observe(FIRDataEventType.value, with: { snap in
            self.mItems.removeAll()

            for child in snap.children.allObjects as! [FIRDataSnapshot] {
                let item = GLItemM(snap: child)

                self.mItems.append(item)
            }

            self.mItems = self.mItems.sorted(by: { item1, item2 in !item1.done && item2.done })

            self.updateUi()
        })
    }

    func stop() {
        // Remove ref listener here
    }

    func onDoneChanged(item: GLItemM, done: Bool) {
        let childUpdate = ["/done": done]

        ref.child("items").child(item.uid).updateChildValues(childUpdate)
    }
}
