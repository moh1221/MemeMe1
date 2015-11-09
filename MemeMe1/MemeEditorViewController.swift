//
//  MemeEditorViewController.swift
//  MemeMe1
//
//  Created by BringMe on 9/20/15.
//  Copyright © 2015 moh. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    var meme: Meme!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //Text attributes Color, size and font style
    let TextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -2.0
    ]
    
    //set keybor high to 0.0
    var currentKeyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let existingMeme = meme {
            // load existing meme from details editor
            setTextField(existingMeme.topText, textField: topTextField)
            setTextField(existingMeme.bottomText, textField: bottomTextField)
            imagePickerView.image = existingMeme.image
            //Enable share and cancel button
            shareButton.enabled = true
            cancelButton.enabled = true
        } else {
            // New meme et Top and Bottom text Field
            setTextField("TOP", textField: topTextField)
            setTextField("BOTTOM", textField: bottomTextField)
            
            //Disable Share button
            shareButton.enabled = false
            if appDelegate.memes.count > 0  {
                cancelButton.enabled = true
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //The Camera button is disabled when app is run on devices without a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Setup Text filed to approximate to the "Impact" font, all caps, white with a black outline
    func setTextField(string: String, textField: UITextField) {
        
        textField.delegate = self
        textField.text = string
        textField.defaultTextAttributes = TextAttributes
        textField.textAlignment = NSTextAlignment.Center
    }
    
    //disable status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func saveMeme() {
        //Create the meme
        if(imagePickerView.image != nil){
            let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, image:
                imagePickerView.image!, memedImage: generateMemedImage())
            appDelegate.memes.append(meme)
        }
    }
    
    func generateMemedImage() -> UIImage {
        //Hide Top and bottom bar to generate MemeImage
        topToolBar.hidden = true
        bottomToolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //enable Top and bottom bar back
        topToolBar.hidden = false
        bottomToolBar.hidden = false
        
        return memedImage
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if(success) {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelShare(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomTextField.isFirstResponder() {
            let kbHeight: CGFloat = getKeyboardHeight(notification)
            let deltaHeight: CGFloat = kbHeight - currentKeyboardHeight
            view.frame.origin.y -= deltaHeight
            currentKeyboardHeight = kbHeight
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y += getKeyboardHeight(notification)
        currentKeyboardHeight = 0
        view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = nil
        }
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(topTextField.text == ""){
            topTextField.text = "TOP"
        }
        
        if(bottomTextField.text == ""){
            bottomTextField.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    //Pick Image using Album option
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true){
            self.shareButton.enabled = true
        }
    }
    
    
    //Pick Image using Camera
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true){
            self.shareButton.enabled = true
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            imagePickerView.image = image
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

