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

    @IBOutlet weak var completeView: UIView!
    @IBOutlet weak var wishNum: UILabel!
    @IBOutlet weak var savingNum: UILabel!
    @IBOutlet weak var boughtNum: UILabel!
    @IBOutlet weak var sliderView: UIView!
    
    var wishs = [Wish]()
    var openWishs : Results<Wish>!
    var savings = [Saving]()
    var datasource: Results<Saving>!
    var completeWishs : Results<Wish>!
    
    var pageViewController: UIPageViewController!
    var wishController: WishListViewController!
    var savingController: SaveListViewController!
    var boughtController: CompletedViewController!
    var controllers = [UIViewController]()
    var sliderImageView: UIImageView!

    var lastPage = 0
    var currentPage: Int = 0 {
        didSet {
            //a line indicator
            let offset = self.view.frame.width / 3.0 * CGFloat(currentPage)
            UIView.animateWithDuration(0.3) { () -> Void in
                self.sliderImageView.frame.origin = CGPoint(x: offset, y: -1)
            }
            
            if currentPage > lastPage {
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .Forward, animated: true, completion: nil)
            }
            else {
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .Reverse, animated: true, completion: nil)
            }
            
            lastPage = currentPage
        }
    }
    override func viewWillAppear(animated: Bool) {
        datasource = uiRealm.objects(Saving)
        openWishs = uiRealm.objects(Wish).filter("isCompleted = false")
        completeWishs = uiRealm.objects(Wish).filter("isCompleted = true")
        let totalSaving = datasource.sum("save") as Double
        wishNum.text = String(openWishs.count)
        savingNum.text = "$"+String(totalSaving)
        boughtNum.text = String(completeWishs.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.navigationController?.navigationBar.translucent = true
       // self.navigationController?.navigationBar.clipsToBounds = true
        pageViewController = self.childViewControllers.first as! UIPageViewController
        
        wishController = storyboard?.instantiateViewControllerWithIdentifier("wishsID") as! WishListViewController
        savingController = storyboard?.instantiateViewControllerWithIdentifier("savingsID") as! SaveListViewController
        boughtController = storyboard?.instantiateViewControllerWithIdentifier("boughtID") as! CompletedViewController
        
        pageViewController.dataSource = self
        
        
        pageViewController.setViewControllers([wishController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        sliderImageView = UIImageView(frame: CGRect(x: 0, y: -1, width: self.view.frame.width / 3.0, height: 3.0))
        sliderImageView.image = UIImage(named: "slider")
        sliderView.addSubview(sliderImageView)
        
        controllers.append(wishController)
        controllers.append(savingController)
        controllers.append(boughtController)
        removeSwipeGesture()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadStats), name: "reloadStat", object: nil)
        //接收页面改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(currentPageChanged), name: "currentPageChanged", object: nil)
       
    }

    func removeSwipeGesture(){
        for view in self.pageViewController!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.scrollEnabled = false
            }
        }
    }
    func reloadStats(notification: NSNotification){
        datasource = uiRealm.objects(Saving)
        openWishs = uiRealm.objects(Wish).filter("isCompleted = false")
        completeWishs = uiRealm.objects(Wish).filter("isCompleted = true")
        let totalSaving = datasource.sum("save") as Double
        wishNum.text = String(openWishs.count)
        savingNum.text = "$"+String(totalSaving)
        boughtNum.text = String(completeWishs.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func segmentBtn(sender: UIButton) {
        currentPage = sender.tag - 100
        NSNotificationCenter.defaultCenter().postNotificationName("reloadStat", object: nil)

    }
    func currentPageChanged(notification: NSNotification) {
        currentPage = notification.object as! Int
    }

}
extension segmentViewController: UIPageViewControllerDataSource {
    
    //Return next page
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKindOfClass(WishListViewController) {
            return savingController
        }
        else if viewController.isKindOfClass(SaveListViewController) {
            return boughtController
        }
        return nil
        
    }
    
    //Return previous page
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKindOfClass(SaveListViewController) {
            return wishController
        }
        else if viewController.isKindOfClass(CompletedViewController) {
            return savingController
        }
        return nil
    }
}

