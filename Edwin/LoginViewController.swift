//
//  LoginViewController.swift
//  Edwin
//
//  Created by Vegard Solheim Theriault on 04/04/15.
//  Copyright (c) 2015 Wrong Bag. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var underLoginConstraint: NSLayoutConstraint!
    @IBOutlet weak var overEdwinLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var edwinLabel: UILabel!
    
    var initialUnderLoginConstraintConstant: CGFloat!
    var initialOverEdwinLabelConstraintConstant: CGFloat!
    
    
    // -------------------------------
    // MARK: View Controller Life Cycle
    // -------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        spinner.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        initialOverEdwinLabelConstraintConstant = overEdwinLabelConstraint.constant
        initialUnderLoginConstraintConstant = underLoginConstraint.constant
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    
    
    // -------------------------------
    // MARK: Text Field Delegate
    // -------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    // -------------------------------
    // MARK: Keyboard Animation Handling
    // -------------------------------
    
    let LOGIN_BUTTON_MIN_DISTANCE_FROM_KEYBOARD:  CGFloat = 16
    let TEXT_FIELD_MIN_DISTANCE_FROM_EDWIN_LABEL: CGFloat = 20
    
    func keyboardWillShow(notification: NSNotification) {
        // Would prefer to do this with UIKeyboardAnimationCurveUserInfoKey, but can't get it working
        var animationCurve = UIViewAnimationCurve.EaseInOut
        NSNumber(integer: 7).getValue(&animationCurve)
        let durationOfAnimation = (notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as NSNumber).doubleValue
        let keyboardEndFrame = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as NSValue).CGRectValue()
        
        let loginButtonBottom = loginButton.frame.origin.y + loginButton.frame.size.height
        let keyboardTopWithSpace = keyboardEndFrame.origin.y - LOGIN_BUTTON_MIN_DISTANCE_FROM_KEYBOARD
        let distanceToMoveButton = loginButtonBottom - keyboardTopWithSpace
        
        if distanceToMoveButton > 0 {
            // Should move
            let movedTopOfUsernameFieldWithSpace = self.usernameTextField.frame.origin.y - distanceToMoveButton - TEXT_FIELD_MIN_DISTANCE_FROM_EDWIN_LABEL
            let bottomOfEdwinLabel = edwinLabel.frame.origin.y + edwinLabel.frame.size.height
            let edwinLabelShouldMoveIfPositive = bottomOfEdwinLabel - movedTopOfUsernameFieldWithSpace
            
            if edwinLabelShouldMoveIfPositive > 0 {
                let newMiddleOfEdwinLabel = movedTopOfUsernameFieldWithSpace / 2.0
                let newOverEdwinLabelConstraintConstant = newMiddleOfEdwinLabel - (edwinLabel.frame.size.height / 2.0)
                overEdwinLabelConstraint.constant = newOverEdwinLabelConstraintConstant
            }
            
            underLoginConstraint.constant += (distanceToMoveButton * underLoginConstraint.multiplier)
            view.setNeedsUpdateConstraints()
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(durationOfAnimation)
            UIView.setAnimationCurve(animationCurve)
            UIView.setAnimationBeginsFromCurrentState(true)
            view.layoutIfNeeded()
            UIView.commitAnimations()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // Would prefer to do this with UIKeyboardAnimationCurveUserInfoKey, but can't get it working
        var animationCurve = UIViewAnimationCurve.EaseInOut
        NSNumber(integer: 7).getValue(&animationCurve)
        
        let durationOfAnimation = (notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as NSNumber).doubleValue
        
        underLoginConstraint.constant = initialUnderLoginConstraintConstant
        overEdwinLabelConstraint.constant = initialOverEdwinLabelConstraintConstant
        view.setNeedsUpdateConstraints()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(durationOfAnimation)
        UIView.setAnimationCurve(animationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)
        view.layoutIfNeeded()
        UIView.commitAnimations()
    }
    
    
    
    
    // -------------------------------
    // MARK: Custom Segue Management
    // -------------------------------
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == SegueIdentifier.PushMainMenuFromLogin {
            MWLog("Should perform the PushMainMenu segue")
            usernameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            return true
        } else if identifier == SegueIdentifier.PushCreateUser {
            MWLog("Should perform the PushCreateUser segue")
            return true
        } else {
            MWLog("Should NOT perform an unknown segue")
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.PushMainMenuFromLogin {
            let mainMenuViewController = segue.destinationViewController as MainMenuViewController
            // Prepare the main menu
            MWLog("Preparing the Main Menu")
        } else if segue.identifier == SegueIdentifier.PushCreateUser {
            let createUserViewController = segue.destinationViewController as CreateUserViewController
            // Prepare create user
            MWLog("Preparing Create User")
        } else {
            MWLog("Preparing for an unknown segue")
        }
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        
        if let id = identifier{
            if id == SegueIdentifier.PopFromMainMenu {
                MWLog("Providing unwind segue for PopFromMainMenu")
                let unwindSegue = PopSegue(identifier: id,
                    source: fromViewController,
                    destination: toViewController,
                    performHandler: { () -> Void in
                })
                
                return unwindSegue
            }
            else if id == SegueIdentifier.PopFromCreateUser {
                MWLog("Providing unwind segue for PopFromCreateUser")
                let unwindSegue = PopSegue(identifier: id,
                    source: fromViewController,
                    destination: toViewController,
                    performHandler: { () -> Void in
                })
                
                return unwindSegue
            }
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        if sender.identifier == SegueIdentifier.PopFromCreateUser {
            // Came back from create user
            MWLog("Came back from Create User")
        } else if sender.identifier == SegueIdentifier.PopFromMainMenu {
            // Came back from main menu
            MWLog("Came back from Main Menu")
        }
    }
}
