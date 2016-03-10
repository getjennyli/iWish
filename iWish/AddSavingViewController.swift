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

    @IBOutlet weak var savingTxtField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var savingNotesTxtField: UITextField!
    var saving: Saving?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      // print(Realm.Configuration.defaultConfiguration.path!)
        savingTxtField.keyboardType = UIKeyboardType.DecimalPad

        
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
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let amount = Double(savingTxtField.text ?? "")
            let notes = savingNotesTxtField.text ?? ""
            
            try! uiRealm.write({ () -> Void in
                saving?.save = amount!
                saving?.saveNotes = notes
            })
            saving = Saving(save: amount!, saveNotes: notes)
            print("saving saved")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
