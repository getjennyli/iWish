//
//  EnteryViewController.swift
//  iWish
//
//  Created by 卡卡 on 2/21/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class EnteryViewController: UIViewController, UITextFieldDelegate {
    
    var wish: Wish?
    // let imagePicker = UIImagePickerController()
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func uploadBtnDidTouch(sender: AnyObject) {
        //imagePicker.allowsEditing = false
      //  imagePicker.sourceType = .PhotoLibrary
        
      //  presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //imagePicker.delegate = self
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
   
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: ImagePicker
   /* func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        imageView.image = selectedImage
        // let imageData = UIImagePNGRepresentation(selectedImage)
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let selectedImage : UIImage = image
        
        imageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            let name = nameTxtField.text ?? ""
            //print("name updated")
            let price = Int(priceTxtField.text ?? "")
            try! uiRealm.write({ () -> Void in
                wish?.name = nameTxtField.text!
                wish?.price = price!
            })
            wish = Wish(name: name, price: price!, isCompleted: false)
            
            
        }
    }

}
