//
//  SavingListViewController.swift
//  iWish
//
//  Created by 卡卡 on 3/9/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class SavingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var savings = [Saving]()
    var datasource : Results<Saving>!
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SavingTableViewCell", forIndexPath: indexPath) as! SavingTableViewCell
        var saving: Saving!
        saving = datasource[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        cell.savingAmtLabel?.text = String(saving.save)
        cell.savingNoteLabel?.text = saving.saveNotes
        cell.dateLabel?.text = dateFormatter.stringFromDate(saving.date)
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            var savingToBeDeleted : Saving!
                savingToBeDeleted = self.datasource[indexPath.row]
           
            try! uiRealm.write({ () -> Void in
                uiRealm.delete(savingToBeDeleted)
                self.reloadTheTable()
            })
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
        else if segue.identifier == "AddSaving" {
            print("Adding new wish")
        }
    }
    
    @IBAction func unwindToWishList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddSavingViewController, saving = sourceViewController.saving {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update existing wish
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                
            } else {
                // Add new wish
                let newIndexPath = NSIndexPath(forRow: savings.count, inSection: 0)
                
                try! uiRealm.write({ () -> Void in
                    uiRealm.add(saving)
                })
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
                
            }
        }
    }


}
