//
//  SaveListViewController.swift
//  iWish
//
//  Created by 卡卡 on 4/20/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class SaveListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var savings = [Saving]()
    var datasource : Results<Saving>!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName("currentPageChanged", object: 1)

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
    func reloadTableData(notification: NSNotification) {
        tableView.reloadData()
    }
    
    func reloadTheTable() {
        do {
            let realm = try Realm()
            datasource = realm.objects(Saving)
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var saving: Saving!
        let cell = tableView.dequeueReusableCellWithIdentifier("SavingCell", forIndexPath: indexPath) as! SavingTableViewCell
        
        saving = datasource[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        cell.savingAmtLabel?.text = "$"+String(saving.save)
        cell.savingNoteLabel?.text = saving.saveNotes
        cell.dateLabel?.text = dateFormatter.stringFromDate(saving.date)
        return cell
    }
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        //if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
        
        let touchPoint = longPressGestureRecognizer.locationInView(self.view)
        if let indexPath = tableView.indexPathForRowAtPoint(touchPoint) {
            let alertController = UIAlertController(title: "", message: nil, preferredStyle: .ActionSheet)
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                print("cancel")
            })
            let delete = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                var savingToBeDeleted : Saving!
                savingToBeDeleted = self.datasource[indexPath.row]
                
                try! uiRealm.write({ () -> Void in
                    uiRealm.delete(savingToBeDeleted)
                    self.reloadTheTable()
                })
                NSNotificationCenter.defaultCenter().postNotificationName("reloadStat", object: nil)
            })
            alertController.addAction(cancel)
            alertController.addAction(delete)
            presentViewController(alertController, animated: true, completion: nil)
            // }
        }
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            var savingToBeDeleted : Saving!
            savingToBeDeleted = self.datasource[indexPath.row]
            
            try! uiRealm.write({ () -> Void in
                uiRealm.delete(savingToBeDeleted)
                self.reloadTheTable()
            })
            NSNotificationCenter.defaultCenter().postNotificationName("reloadStat", object: nil)

        }

        return [deleteAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSaving" {
            let savingDetailViewController = segue.destinationViewController as? AddSavingViewController
            
            if let selectedSavingCell = sender as? SavingTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSavingCell)
                let selectedSaving = datasource[indexPath!.row]
                savingDetailViewController!.saving = selectedSaving
                
            }
            
        }
        else if segue.identifier == "addSaving" {
            print("Adding new wish")
        }
    }
    
    @IBAction func unwindToSavingList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddSavingViewController, saving = sourceViewController.saving {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update existing wish
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add new wish
                let newIndexPath = NSIndexPath(forRow: savings.count, inSection: 0)
                
                try! uiRealm.write{
                    uiRealm.add(saving)
                }
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
                
            }
        }
    }

}
