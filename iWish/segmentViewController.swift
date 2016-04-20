//
//  segmentViewController.swift
//  iWish
//
//  Created by 卡卡 on 4/16/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class segmentViewController: UIViewController {

    @IBOutlet weak var wishView: UIView!
    @IBOutlet weak var savingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        wishView.hidden = false
        savingView.hidden = true
      //  print(Realm.Configuration.defaultConfiguration.path!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func segmentBtn(sender: UIButton) {
        switch sender.tag {
        case 1:
            wishView.hidden = false
            savingView.hidden = true
        case 2:
            wishView.hidden = true
            savingView.hidden = false
        case 3:
            wishView.hidden = false
            savingView.hidden = true
        default: ()
            break;
        }
    }

}
