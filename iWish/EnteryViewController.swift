//
//  EnteryViewController.swift
//  iWish
//
//  Created by 卡卡 on 2/21/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit
import RealmSwift

class EnteryViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var activeField: UITextField?
    var wish: Wish?
    //var saving: Saving?
    // let imagePicker = UIImagePickerController()
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    
    @IBOutlet weak var notesTxtField: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
 
    @IBOutlet weak var uploadImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //imagePicker.delegate = self
        // Do any additional setup after loading the view.
        if let wish = wish {
            let image: UIImage = UIImage(data:wish.image,scale:0.5)!
            navigationItem.title = wish.name
            nameTxtField.text = wish.name
            priceTxtField.text = String(wish.price)
            notesTxtField.text = wish.notes
            progressView.progress = Float(wish.progress)
            progressLabel.text = wish.progressLabel
            uploadImage.image = image
        }
       // progressView.progress = Float(saving!.save/wish!.price)
        priceTxtField.keyboardType = UIKeyboardType.DecimalPad
        uploadImage.userInteractionEnabled = true;
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(_:)))
        uploadImage.addGestureRecognizer(tapGestureRecognizer)

        
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resouxrces that can be recreated.
    }
   
    // MARK: UITextFieldDelegate
   
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: ImagePicker
    func imageTapped(img: AnyObject)
    {
        let actionSheet = UIAlertController(title: "Photo", message: nil, preferredStyle: .ActionSheet)
        
        // show choices to the user so the user can choose from take photo, choose from library and cancel
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .Default, handler: {action in
            self.takePhoto()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose From Library", style: .Default, handler: {action in
            self.choosePhoto()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    // function which allow the user to take photo
    func takePhoto(){
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil{
            imagePickerController.sourceType = .Camera
            imagePickerController.cameraCaptureMode = .Photo
            imagePickerController.delegate = self
            
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
        else{
            noCamera()
        }
        
    }
    
    // choose photo from library
    func choosePhoto(){
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        uploadImage.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(
            alertVC,
            animated: true,
            completion: nil)
    }

    
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
            var image: NSData = UIImagePNGRepresentation(uploadImage.image!)!

            try! uiRealm.write({ () -> Void in
                wish?.name = nameTxtField.text!
                wish?.price = price!
                wish?.progress = progresss
                wish?.progressLabel = progressLabel!
                wish?.notes = notes
                wish?.image = image
            })
            wish = Wish(name: name, price: price!, isCompleted: false, progress: progresss, progressLabel: progressLabel!, notes: notes, image: image)
            
            
        }
    }

}
