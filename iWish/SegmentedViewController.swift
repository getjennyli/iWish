//
//  SegmentedViewController.swift
//  iWish
//
//  Created by 卡卡 on 3/24/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class SegmentedViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstView.hidden = false
        secondView.hidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            firstView.hidden = false
            secondView.hidden = true
            
        case 1:
            firstView.hidden = true
            secondView.hidden = false
            print("second View did touch")
        default:
            break;
        }
    }
    
    

}
