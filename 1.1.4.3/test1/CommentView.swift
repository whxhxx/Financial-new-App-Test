//
//  CommentView.swift
//  test1
//
//  Created by WangHaixin on 12/22/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//

import UIKit
import Firebase
class CommentView: UIViewController, UITextViewDelegate, UITextFieldDelegate
{

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var contactText: UITextField!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad()
    {
        commentText.layer.cornerRadius = 5
        commentText.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.3).CGColor
        commentText.layer.borderWidth = 1
        commentText.clipsToBounds = true
        commentText.text = "Comments:"
        commentText.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.3).CGColor
        submitButton.layer.borderWidth = 1
        submitButton.clipsToBounds = true
        
        super.viewDidLoad()
    }

    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView.textColor == UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
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
    

    @IBAction func submitButtonPressed(sender: UIButton)
    {
        let x = Reachability.reachCheck.isConnectedToNetwork()
        if x == false
        {
            let myAlert = UIAlertController(title: "No Network Connection", message: "Try later", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                {
                    (ACTION) in
            }
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let dateInFormat = dateFormatter.stringFromDate(NSDate())
        
        let weblink = DataService.ds.GMBP_FEEDBACK
        let feedback = ["time": dateInFormat, "name": nameText.text, "contact": contactText.text, "comment": commentText.text]
        
        
        weblink.childByAppendingPath(dateInFormat).updateChildValues(feedback, withCompletionBlock:
            {
                (error:NSError?, ref:Firebase!) in
                if (error != nil)
                {
                    print("Feedback could not be upload.")
                    let myAlert = UIAlertController(title: "Upload Failed", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                        {
                            (ACTION) in
                    }
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                }
                else
                {
                    print("feedback uploaded")
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    let hourAndMinute = dateFormatter.stringFromDate(NSDate())
                    
                    let myAlert = UIAlertController(title: "Thanks for your feedback!", message: "Upload at \(hourAndMinute)", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                        {
                            (ACTION) in
                    }
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    
                    self.nameText.text = nil
                    self.contactText.text = nil
                    self.commentText.text = nil
                    
                }
        })
        
        
        
    }




}
