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
    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var wishNum: UILabel!
    @IBOutlet weak var savingNum: UILabel!
    @IBOutlet weak var boughtNum: UILabel!
    
    var wishs = [Wish]()
    var openWishs : Results<Wish>!
    var savings = [Saving]()
    var datasource: Results<Saving>!
    var completeWishs : Results<Wish>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.navigationController?.navigationBar.translucent = true
       // self.navigationController?.navigationBar.clipsToBounds = true


        wishView.hidden = false
        savingView.hidden = true
        completeView.hidden = true
        datasource = uiRealm.objects(Saving)
        openWishs = uiRealm.objects(Wish).filter("isCompleted = false")
        completeWishs = uiRealm.objects(Wish).filter("isCompleted = true")
        let totalSaving = datasource.sum("save") as Double
        wishNum.text = String(openWishs.count)
        savingNum.text = String(totalSaving)
        boughtNum.text = String(completeWishs.count)

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func segmentBtn(sender: UIButton) {
        switch sender.tag {
        case 1:
            wishView.hidden = false
            savingView.hidden = true
            completeView.hidden = true
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)

        case 2:
            wishView.hidden = true
            savingView.hidden = false
            completeView.hidden = true
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)


        case 3:
            wishView.hidden = true
            savingView.hidden = true
            completeView.hidden = false
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)


        default: ()
            break;
        }
    }

}
