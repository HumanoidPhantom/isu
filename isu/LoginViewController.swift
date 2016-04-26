//
//  LoginViewController.swift
//  isu
//
//  Created by Phantom on 16/07/15.
//  Copyright (c) 2015 Phantom. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var patronymicTextField: UITextField!
    
    @IBOutlet weak var bookNumberTextField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
        self.startWorkWithInformation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let checkData = DataRequest()
        
        if checkData.coreDataHasData() {
            self.showTabBarController(false)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    func showAlertViewWithMessage(message : String)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case self.surnameTextField :
            self.nameTextField.becomeFirstResponder()
        case self.nameTextField :
            self.patronymicTextField.becomeFirstResponder()
        case self.patronymicTextField :
            self.bookNumberTextField.becomeFirstResponder()
        case self.bookNumberTextField :
            self.startWorkWithInformation()
        default :
            break
        }
        textField.resignFirstResponder()
        return true
    }
    
    func startWorkWithInformation() {
        self.view.endEditing(true)
        
        self.loadingView.hidden = false
        self.activityIndicatorView.startAnimating()
        
        let dataRequest = DataRequest()
        
        dataRequest.getDataFromServer(self.nameTextField.text!, second_name: self.surnameTextField.text!, parent_name: self.patronymicTextField.text!, auth_number: self.bookNumberTextField.text!, success:
            { () -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.showTabBarController(true)
                    self.loadingView.hidden = true
                    self.activityIndicatorView.stopAnimating()
                })
            },
            failure: { (message) -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.loadingView.hidden = true
                    self.activityIndicatorView.stopAnimating()
                    
                })
                
                self.showAlertViewWithMessage(message)
        })
    }
    
    func showTabBarController(animated: Bool) {
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? TabBarController else {
            print("error")
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
}

