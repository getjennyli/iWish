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
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.view.addGestureRecognizer(longPressRecognizer)
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
    // gesture
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        //if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
        
        let touchPoint = longPressGestureRecognizer.locationInView(self.view)
        if let indexPath = tableView.indexPathForRowAtPoint(touchPoint) {
            let alertController = UIAlertController(title: "", message: nil, preferredStyle: .ActionSheet)
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                print("cancel")
            })
            let bought = UIAlertAction(title: "WANT", style: .Default, handler: { (action) -> Void in
                var wishToBeUpdated: Wish!
                wishToBeUpdated = self.openWishs[indexPath.row]
                try! uiRealm.write({ () -> Void in
                    wishToBeUpdated.isCompleted = !wishToBeUpdated.isCompleted
                    self.reloadTheTable()
                })
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            let delete = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                var wishToBeDeleted: Wish!
                wishToBeDeleted = self.openWishs[indexPath.row]
                try! uiRealm.write({ () -> Void in
                    uiRealm.delete(wishToBeDeleted)
                    self.reloadTheTable()
                })
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(cancel)
            alertController.addAction(bought)
            alertController.addAction(delete)
            presentViewController(alertController, animated: true, completion: nil)
            // }
        }
    }
    
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
        if progresss <= 0 {
            progresss = 0
        } else if progresss <= 1 {
            progresss = totalSaving/(wish?.price)!
        } else {
            progresss = 1
        }
        cell.progressView.progress = Float(progresss)
        cell.progressLabel.text = String(format: "%.0f", (progresss*100))+"%"
        cell.nameLabel?.text = wish.name
        cell.priceLabel?.text = "$"+String(wish.price)
        cell.notesLabel?.text = wish.notes
        cell.imgView?.image = image
        return cell
    }
    
    // TableViewCell Swipe Action
   /* func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: " ") { (deleteAction, indexPath) -> Void in
            
            var wishToBeDeleted : Wish!
            wishToBeDeleted = self.openWishs[indexPath.row]
            try! uiRealm.write({ () -> Void in
                uiRealm.delete(wishToBeDeleted)
                self.reloadTheTable()
            })
            NSNotificationCenter.defaultCenter().postNotificationName("reloadStat", object: nil)

        }
        deleteAction.backgroundColor=UIColor(patternImage: UIImage(named: "deleteBtn")!)

        return [deleteAction]
    }*/
    
    
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