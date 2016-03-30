//
//  WishListViewController.swift
//  iWish
//
//  Created by 卡卡 on 2/20/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class WishListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var wishs = [Wish]()
    var openWishs : Results<Wish>!
    var completedWishs : Results<Wish>!
    var savings = [Saving]()
    var datasource: Results<Saving>!
    //var saving = [Saving]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTheTable()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTheTable()
        // Do any additional setup after loading the view.
    }

   
    func reloadTheTable() {
        
        do {
            let realm = try Realm()
            
            openWishs = realm.objects(Wish).filter("isCompleted = false")
            completedWishs = realm.objects(Wish).filter("isCompleted = true")
            
            tableView?.reloadData()
        } catch {
            
        }
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCell
        headerCell.contentView.backgroundColor = UIColor.cyanColor()
        headerCell.wantsLabel.text = String(openWishs.count)
        headerCell.completedLabel.text = String(completedWishs.count)
        let totalSave : Int = uiRealm.objects(Saving).sum("save")
        headerCell.savingLabel.text = String(totalSave)
        return headerCell.contentView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    

    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Open Wishs"
        }
        return "Completed Wishs"
    }

    // LongPress Cell to move, http://www.freshconsulting.com/create-drag-and-drop-uitableview-swift/
    
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return openWishs.count
        }
        return completedWishs.count
    }
 /*   @IBAction func indexChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("WishTableViewCell",forIndexPath: indexPath) as! WishTableViewCell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SavingTableViewCell",forIndexPath: indexPath) as! SavingTableViewCell
        }
        self.tableView.reloadData()
    }*/

        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("WishTableViewCell", forIndexPath: indexPath) as! WishTableViewCell
            var wish: Wish!
        //    var saving: Saving!
            var saving: Saving!
            if indexPath.section == 0 {
                wish = openWishs[indexPath.row]
            }
            //let wish = datasource[indexPath.row]
            else {
                wish = completedWishs[indexPath.row]
            }
           // let progress = saving.save/(wish?.price)!
            cell.nameLabel?.text = wish.name
            cell.priceLabel?.text = String(wish.price)
            cell.progressView.progress = Float(wish.progress)
            cell.progressLabel.text = wish.progressLabel
            cell.notesLabel?.text = wish.notes
            return cell
            
        }
    
    // TableViewCell Swipe Action
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            var wishToBeDeleted : Wish!
            if indexPath.section == 0 {
                wishToBeDeleted = self.openWishs[indexPath.row]
            }
            else {
                wishToBeDeleted = self.completedWishs[indexPath.row]
            }
            try! uiRealm.write({ () -> Void in
                uiRealm.delete(wishToBeDeleted)
                self.reloadTheTable()
            })
        }
        let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Done") { (doneAction, indexPath) -> Void in
            var wishToBeUpdated : Wish!
            if indexPath.section == 0 {
                wishToBeUpdated = self.openWishs[indexPath.row]
            }
            else {
                wishToBeUpdated = self.completedWishs[indexPath.row]
            }
           try! uiRealm.write({ () -> Void in
                wishToBeUpdated.isCompleted = true
                self.reloadTheTable()
            })
        }
        return [deleteAction, doneAction]
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let wishDetailViewController = segue.destinationViewController as? EnteryViewController
            
            if let selectedWishCell = sender as? WishTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWishCell)
                if indexPath!.section == 0 {
                    let selectedWish = openWishs[indexPath!.row]
                    wishDetailViewController!.wish = selectedWish
                    
                } else {
                    let selectedWish = completedWishs[indexPath!.row]
                    wishDetailViewController!.wish = selectedWish
                }
            }
           
        }
        else if segue.identifier == "AddItem" {
            print("Adding new wish")
        }
    }
    
    @IBAction func unwindToWishList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? EnteryViewController, wish = sourceViewController.wish {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update existing wish
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)

            } else {
                // Add new wish
                let newIndexPath = NSIndexPath(forRow: wishs.count, inSection: 0)
        
                try! uiRealm.write({ () -> Void in
                    uiRealm.add(wish)
                })
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
            
            }
        }
    }
    
 
}
