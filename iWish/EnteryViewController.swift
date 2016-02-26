//
//  EnteryViewController.swift
//  iWish
//
//  Created by 卡卡 on 2/21/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class EnteryViewController: UIViewController {
    
    var wish: Wish?
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let wish = wish {
            navigationItem.title = wish.name
            nameTxtField.text = wish.name
            priceTxtField.text = String(wish.price)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveWish(selectedWish:Wish!) {
        
        if selectedWish != nil{
           try! uiRealm.write({ () -> Void in
                selectedWish.name = nameTxtField.text!
                selectedWish.price = Int(priceTxtField.text!)!
            
            })
        
        } else {
            let newWish = Wish()
            newWish.name = nameTxtField.text!
            newWish.price = Int(priceTxtField.text!)!
    
            try! uiRealm.write({ () -> Void in
                uiRealm.add(newWish)
        })
        }
    }
   
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            let name = nameTxtField.text ?? ""
            //print("name updated")
            let price = Int(priceTxtField.text ?? "")
            //print("price updated")
            try! uiRealm.write({ () -> Void in
                wish?.name = nameTxtField.text!
                wish?.price = price!
            })
            print("tried writing to realm")
             wish = Wish(name: name, price: price!)
            print ("updated wish")
            
            
        }
    }

}
