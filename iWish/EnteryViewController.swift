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
    @IBOutlet weak var notesTxtField: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var progressLabel: UILabel!
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
            notesTxtField.text = wish.notes
            progressView.progress = Float(wish.progress)
            progressLabel.text = wish.progressLabel
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
    var numberFormatter: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        return formatter
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTxtField.text ?? ""
            let price = Double(priceTxtField.text ?? "")
            var progresss = 100/price!
            let notes = notesTxtField.text ?? ""
            if progresss <= 1 {
                progresss = 100/price!
            } else {
                progresss = 1

            }
            let progressLabel = numberFormatter.stringFromNumber(progresss)
            
            try! uiRealm.write({ () -> Void in
                wish?.name = nameTxtField.text!
                wish?.price = price!
                wish?.progress = progresss
                wish?.progressLabel = progressLabel!
                wish?.notes = notes
            })
            wish = Wish(name: name, price: price!, isCompleted: false, progress: progresss, progressLabel: progressLabel!, notes: notes)
            
            
        }
    }

}
