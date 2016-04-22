//
//  CompletedViewController.swift
//  iWish
//
//  Created by 卡卡 on 4/20/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var wishs = [Wish]()
    var openWishs : Results<Wish>!
    var savings = [Saving]()
  //  var datasource: Results<Saving>!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName("currentPageChanged", object: 2)

        reloadTheTable()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTheTable()
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadTableData), name: "reload", object: nil)

    }
    
    func reloadTheTable() {
        
        do {
            let realm = try Realm()
            
            openWishs = realm.objects(Wish).filter("isCompleted = true")
            tableView?.reloadData()
        } catch {
            
        }
    }
    func reloadTableData(notification: NSNotification) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    // LongPress Cell to move, http://www.freshconsulting.com/create-drag-and-drop-uitableview-swift/
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openWishs.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var wish: Wish!
        let cell = tableView.dequeueReusableCellWithIdentifier("WishTableViewCell", forIndexPath: indexPath) as! WishTableViewCell
        wish = openWishs[indexPath.row]
        let image: UIImage = UIImage(data:wish.image!,scale:1.0)!
        
        let totalSaving = uiRealm.objects(Saving).sum("save") as Double
        var progresss = totalSaving/(wish?.price)!
        if progresss <= 1 {
            progresss = totalSaving/(wish?.price)!
        } else {
            progresss = 1
        }
        cell.progressView.progress = Float(progresss)
        cell.progressLabel.text = String(progresss)
        cell.nameLabel?.text = wish.name
        cell.priceLabel?.text = String(wish.price)
        cell.notesLabel?.text = wish.notes
        cell.imgView?.image = image
        return cell
    }
    
    // TableViewCell Swipe Action
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            var wishToBeDeleted : Wish!
            wishToBeDeleted = self.openWishs[indexPath.row]
            
            try! uiRealm.write({ () -> Void in
                uiRealm.delete(wishToBeDeleted)
                self.reloadTheTable()
            })
        }
        let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Done") { (doneAction, indexPath) -> Void in
            var wishToBeUpdated : Wish!
            wishToBeUpdated = self.openWishs[indexPath.row]
            
            try! uiRealm.write({ () -> Void in
                wishToBeUpdated.isCompleted = false
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
                let selectedWish = openWishs[indexPath!.row]
                wishDetailViewController!.wish = selectedWish
            }
            
        }
        else if segue.identifier == "AddItem" {
            print("Adding new wish")
        }
    }
    
  /*  @IBAction func unwindToWishList(sender: UIStoryboardSegue) {
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
    }*/
    
}