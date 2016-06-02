//  PAGE -- login
//  ViewController.swift
 
//  Created by WangHaixin on 11/2/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
 
import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    /*
    var: posts for tableview data; emailField and passwordField link to UITextField; fake flag for user identification
    */
    var posts = [Post]()
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var fakeFlag = 0
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginAI: UIActivityIndicatorView!
    //func:touch screen ends editing
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    //func:keyboard control
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // func:general function for show error message within an Alert Action
    func showError(title: String, msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /*
    viewDidLoad runs when this view did load in window
    */
    override func viewDidLoad()
    {
        let id = NSUserDefaults.standardUserDefaults().objectForKey("deviceId") as! String?
        let savedAuthDataUid = NSUserDefaults.standardUserDefaults().objectForKey("auth") as! String?
        
        
        // if it's old user
        if savedAuthDataUid != nil
        {
            self.emailField.hidden = true
            self.passwordField.hidden = true
            self.loginButton.hidden = true
            self.usernameLabel.hidden = true
            self.passwordLabel.hidden = true
            self.welcomeLabel.hidden = false
            self.loginAI.hidden = false
            self.loginAI.startAnimating()
        }
        // else it's a new user for first time login
        else
        {
            self.emailField.hidden = false
            self.passwordField.hidden = false
            self.loginButton.hidden = false
            self.usernameLabel.hidden = false
            self.passwordLabel.hidden = false
            self.welcomeLabel.hidden = true
            self.loginAI.hidden = true
            self.loginAI.stopAnimating()
        }
        
        // compare info  in USERS database, the info list is : snapshot
        DataService.ds.GMBP_USERS.observeEventType(.Value, withBlock:
        {   snapshot in
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
            {
                for snap in snapshots
                {
                    let key = snap.key
                    // if Fitrbase has this device id:
                    if  savedAuthDataUid == key
                    {
                        //if email and password under this id match local informations
                        if id == snap.value.objectForKey("id") as? String
                        {
                            print("PRE-LOGIN CHECK : uid and deviceID info MATCH => LOGIN")
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            //remove ob
                            DataService.ds.GMBP_USERS.removeAllObservers()
                            return
                        }
                    }
                }
                print("pre-check fail") // no such data in database: which means it's new user
            }
        })
    }
    
    /*
    when LOGIN btn pressed
    */
    @IBAction func BtnPressed(sender: UIButton)
    {
        // if email and password are not empty
        if let email = emailField.text where email != "" , let pwd = passwordField.text where pwd != ""
        {
            // check user authentication
            DataService.ds.GMBP_BASE.authUser(email, password: pwd, withCompletionBlock:
            { error, authData in
                // has error-----------------------------------------------------
                if error != nil
                {
                    print(error)
                    if error.code == STATUS_ACCOUNT_NOEXIST
                    {
                        self.showError("the user doesn't exist", msg: String(error.code))
                        // --uncomment from here to create a new user for new typy-in email&password
                    }
                    else
                    {
                        self.showError("unable to login", msg: String(error.code))
                    }
                }
                else  // no error---------------------------------------------------------------------------------------
                {
                    // check database users tree: if email already exist: fake user
                    let observerInBtn =  DataService.ds.GMBP_USERS.observeEventType(.Value, withBlock:
                    {
                        snapshot in
                        self.posts = []
                        if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
                        {
                            for snap in snapshots
                            {
                                if snap.value.objectForKey("email") as! String == email
                                {
                                    print("====> FAKE USER <====")
                                    self.showError("unauthorized device", msg: "")

                                    self.fakeFlag = 1
                                    Firebase.goOffline()   // cut off connection
                                    return
                                }
                            }
                            print("btn check: ID NOT FOUND in loop")
                            NSThread.sleepForTimeInterval(1)
                            // if program arrive here meaning it's a new user which have no info in Firebase
                            if self.fakeFlag == 0
                            {
                                print("fakeflag = 0")
                                
                                let id  = UIDevice.currentDevice().identifierForVendor?.UUIDString
                                let  userInfo = ["email":email as String, "password":pwd as String, "id":id! as String]
                                
                                // create this user in database users tree
                                DataService.ds.createFirebaseUser(authData.uid, user: userInfo)
                                // store email and password locally for next time auto-login
                                NSUserDefaults.standardUserDefaults().setObject(email, forKey: "email")
                                NSUserDefaults.standardUserDefaults().setObject(pwd, forKey: "password")
                                NSUserDefaults.standardUserDefaults().setObject(authData.uid, forKey: "auth")
                                NSUserDefaults.standardUserDefaults().setObject(id, forKey: "deviceId")


                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        }
                    })
                    DataService.ds.GMBP_USERS.removeObserverWithHandle(observerInBtn)
                }
            })
        }
        else// no email or password input
        {
            showError("Email and Password required", msg: "need enter Email or Password")
        }
    }
    
   

    // class default function
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // empty. Dispose of any resources that can be recreated.
    }
}

