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
    
    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!

    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var takePhoto: UIBarButtonItem!
    
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        
    textFieldDidBeginEditing(topTextField)
    textFieldDidBeginEditing(bottomTextField)
    
    composeButton.isEnabled = false
        
    setProperty(textfield: topTextField)
    setProperty(textfield: bottomTextField)
        
        // Checking if Camera is available for this device
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
          print("All Good")
        }
        else {
            takePhoto.isEnabled = false
        }
        
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
        generateSourceType(type: .photoLibrary)
    }
   
    //MARK: IMAGEPICKER
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func takeAnImage(_ sender: Any) {
       generateSourceType(type: .camera)
    }
    
    @objc func cameraPickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePickerView.image = image
            
            dismiss(animated: true, completion: nil)
        }
        
}

    // MARK: Text Property
    func setProperty(textfield: UITextField) {
        
        // sets text attributes with NS Attributed String Key[
   
        let memeTextAttributes:[String: Any] = [
            // Outline color of text
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            // Color of text
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            // Font
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            // Font Width
            NSAttributedStringKey.strokeWidth.rawValue: -3.0]
        
        //sets text properties using meme dictionary below
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        textfield.delegate = self
        
        if textfield == topTextField {
            topTextField.attributedPlaceholder = NSAttributedString(string: "Top", attributes:
            [NSAttributedStringKey.foregroundColor: UIColor.white])
        
            
        } else if textfield == bottomTextField {
            bottomTextField.attributedPlaceholder = NSAttributedString(string: "Bottom", attributes:
                [NSAttributedStringKey.foregroundColor: UIColor.white])
        }
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }
    
    
    
    //MARK: Keyboard Functions Subscribe/Unsuscribe:
    
    //resign first responder to clear keyboard 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
       
      
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide( _ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0

        }
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    //MARK: Other Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == topTextField {
            topTextField.attributedPlaceholder = nil
        } else if textField == bottomTextField {
            bottomTextField.attributedPlaceholder = nil
        }
    }
    
   
    // MARK: MEME Creation and Functions
    
    
    func generateMemedImage() -> UIImage {
        
        navbar.isHidden = true
        toolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
        
    }
    
    func save(memedImage: UIImage) {
        
        //Create the Meme
      
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
     
        
    }
    
    @IBAction func composePressed(_ sender: Any) {
        
        cancelButton.isEnabled = true
        view.frame.origin.y = 0
        let memedImage = generateMemedImage()
        
        
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
            vc.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                
                
                if completed {
                    self.save(memedImage: memedImage)
                    self.dismiss(animated: true, completion: nil)
                }
                self.resetComposeUI()
                
                }
        present(vc, animated: true, completion: nil)
      }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
          resetUI()
          performSegue(withIdentifier: "cancelMemeCreate", sender: self)
        }
    
    func resetUI() {
        imagePickerView.image = nil
        composeButton.isEnabled = true
        cancelButton.isEnabled = true
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        }
    
    func resetComposeUI() {
        self.view.frame.origin.y = 0
        self.navbar.isHidden = false
        self.toolbar.isHidden = false
        self.composeButton.isEnabled = true
        self.cancelButton.isEnabled = true
        
    }
    
    func generateSourceType(type: UIImagePickerControllerSourceType) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = type
        
        present(pickerController, animated: true, completion: nil)
        
        composeButton.isEnabled = true
        cancelButton.isEnabled = true
        
    }

    
    

}


