//
//  ClearCachePage.swift
//  test1
//
//  Created by WangHaixin on 12/14/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//

import UIKit

class ClearCachePage: UIViewController
{

    @IBOutlet weak var clearButton: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        clearButton.layer.cornerRadius = 10
        clearButton.layer.borderColor = UIColor.redColor().colorWithAlphaComponent(0.3).CGColor
        clearButton.layer.borderWidth = 1
    }

    @IBAction func clearButtonPressed(sender: UIButton)
        {
            let myAlert = UIAlertController(title: "Are you sure to clear all the local records?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let YesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default)
            {
                (ACTION) in
    
                //avoid id and auth from deleting , save it
                let savedId = NSUserDefaults.standardUserDefaults().objectForKey("deviceId") as! String?
                let savedAuthDataUid = NSUserDefaults.standardUserDefaults().objectForKey("auth") as! String?
                
                NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
              
                //avoid id and auth from deleting, restore it
                NSUserDefaults.standardUserDefaults().setObject(savedAuthDataUid, forKey: "auth")
                NSUserDefaults.standardUserDefaults().setObject(savedId, forKey: "deviceId")

                let doneAlert = UIAlertController(title: "Record Cleared", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(ACTION) in}
                doneAlert.addAction(okAction)
                self.presentViewController(doneAlert, animated: true, completion: nil)
            }
            
            let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default){(ACTION) in}
            myAlert.addAction(YesAction)
            myAlert.addAction(NoAction)
    
            self.presentViewController(myAlert, animated: true, completion: nil)
        }


}
