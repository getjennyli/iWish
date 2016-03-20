//
//  AddSavingViewController.swift
//  iWish
//
//  Created by 卡卡 on 3/6/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class AddSavingViewController: UIViewController, UITextFieldDelegate {
    var saving: Saving?
    
    @IBOutlet weak var savingTxtField: UITextField!
    @IBOutlet weak var savingNotesTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      // print(Realm.Configuration.defaultConfiguration.path!)
        savingTxtField.keyboardType = UIKeyboardType.DecimalPad
        if let saving = saving {
            savingTxtField.text = String(saving.save)
            savingNotesTxtField.text = saving.saveNotes
        }
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtnDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveBtnDidTouch(sender: AnyObject) {
        let amount = Double(savingTxtField.text ?? "")
        let notes = savingNotesTxtField.text ?? ""
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        
        saving = Saving(save: amount!, saveNotes: notes, date: currentDate)
        let realm = try! Realm()
        try! realm.write(){
            //saving?.save = amount!
            //saving?.saveNotes = notes
            realm.add(saving!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let amount = Double(savingTxtField.text ?? "")
            let notes = savingNotesTxtField.text ?? ""
            
            try! uiRealm.write({ () -> Void in
                saving?.save = amount!
                saving?.saveNotes = notes
            })
            saving = Saving(save: amount!, saveNotes: notes)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }*/
    
}
