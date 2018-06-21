//
//  ViewController.swift
//  imagePickerPractice
//
//  Created by Christopher Tropiano on 6/5/18.
//  Copyright © 2018 Christopher Tropiano. All rights reserved.
//

import UIKit

//In order to use the UIImagePicker delegate you have to use UI Navigation delegate.

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!

    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    override func viewDidLoad() {
        
    setTopProperty()
    setBottomProperty()
        
        // Checking if Camera is available for this device
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
          print("All Good")
        }
        else {
            print("Sorry cant take picture")
        }
        
        //sets text properties using meme dictionary below
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
 
    
    @IBAction func pickAnImage(_ sender: Any) {
        //create an instance of the picker controller
        let pickerController = UIImagePickerController()
        
        //Sets this as a delegate of the protocol
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        
        //Present the controller to the UI
        present(pickerController, animated: true, completion: nil)
        
    }
   
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func takeAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        
        present(pickerController, animated: true, completion: nil)
        
    }
    @objc func cameraPickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePickerView.image = image
            
            dismiss(animated: true, completion: nil)
        }
        
}

    func setTopProperty() {
        topTextField.delegate = self
        topTextField.placeholder = "TOP"
        topTextField.textAlignment = .center
        
   
    }
    
    func setBottomProperty() {
    bottomTextField.delegate = self
    bottomTextField.textAlignment = .center
    bottomTextField.placeholder = "BOTTOM"
       
    }
    
    //resign first responder to clear keyboard 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
    
    //sets text attributes
    
    let memeTextAttributes:[String: Any] = [
        //Outline color of text
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        //Color of text
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        //Font
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
 
        //Font Width
        NSAttributedStringKey.strokeWidth.rawValue: -3.0 ]
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }



}




