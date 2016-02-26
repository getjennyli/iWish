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
    var datasource : Results<Wish>!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTheTable()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTheTable()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTheTable() {
        do {
            let realm = try Realm()
            datasource = realm.objects(Wish)
            tableView?.reloadData()
        } catch {
            
        }
    }
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return datasource.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "WishTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WishTableViewCell
            
            let wish = datasource[indexPath.row]
            
            cell.nameLabel.text = wish.name
            cell.priceLabel.text = String(wish.price)
            
            return cell
        }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            var wishToBeDeleted : Wish!
            wishToBeDeleted = self.datasource[indexPath.row]
            
            try! uiRealm.write({ () -> Void in
                uiRealm.delete(wishToBeDeleted)
                self.reloadTheTable()
            })
        }
       
        return [deleteAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let wishDetailViewController = segue.destinationViewController as? EnteryViewController
            
            if let selectedWishCell = sender as? WishTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWishCell)
                let selectedWish = datasource[indexPath!.row]
                wishDetailViewController!.wish = selectedWish
            }
           
        }
        else if segue.identifier == "AddItem" {
           let wishDetailViewController = segue.destinationViewController as? EnteryViewController
          //  let name = "New Wish"
           // let price = 0
           // wishDetailViewController!.wish = Wish(name: name, price: price)
            print("Adding new wish")
        }
    }
    
    @IBAction func unwindToWishList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? EnteryViewController, wish = sourceViewController.wish {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                print(wish.name)
                // Update existing wish
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)

            } else {
                // Add new wish
                print(wish.name)
                let newIndexPath = NSIndexPath(forRow: wishs.count, inSection: 0)
               // var unwindWish = Wish()
               // unwindWish.name = wish.name
               // unwindWish.price = wish.price
                try! uiRealm.write({ () -> Void in
                    uiRealm.add(wish)
                })
               // wishs.append(wish)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
            
            }
        }
    }
}