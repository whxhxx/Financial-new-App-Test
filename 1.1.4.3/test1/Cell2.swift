//
//  Cell2.swift
//  test1
//
//  Created by WangHaixin on 12/8/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//

import UIKit
import Firebase

class Cell2: UITableViewCell
{

        @IBOutlet weak var theButton: UIButton!
        let imageReadZone = "zone1"
        
        var theImage = UIImage()
        var imageInCell : UIImageView!
        @IBOutlet weak var  textInCell : UITextView!
        @IBOutlet weak var titleText: UILabel!
        var post :Post!
        var imgString : NSData?
        var smallImgString: NSData?
    var imgAddress: String?

    
        override func awakeFromNib()
        {
            super.awakeFromNib()
        }
        
        
        override func setSelected(selected: Bool, animated: Bool)
        {
            super.setSelected(selected, animated: animated)
            
        }
        
        func configureCell(post: Post)
        {
            self.post = post
            
            
            
            if post.title != ""
            {
                self.titleText.text = post.title
                self.titleText.lineBreakMode = NSLineBreakMode.ByWordWrapping
            }
            
            //new image  ======   ======   ======
            if post.text != "y"
            {
                self.textInCell.frame.size.height = 50

                if post.time != ""
                {
                    self.textInCell.text = post.time
                }
                else
                {
                    self.textInCell.text = post.postDescription
                }
                if post.smallImage == ""
                {
                    
                    let address = self.imageReadZone + "/" + post.postKey
                    self.imgAddress = address
                    // print("= = No Cache = =") : read image from IMAGE Node
                    DataService.ds.GMBP_IMAGE.childByAppendingPath(self.imageReadZone).childByAppendingPath(post.postKey).observeSingleEventOfType(.Value, withBlock:
                        {   snapshot in
                            if snapshot.hasChild("imageString")
                            {
                                if let data = snapshot.value.objectForKey("imageString") as! String?
                                {
                                    let decodedData = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions(rawValue:0))
                                    let img = UIImage(data: decodedData!)!
                                    self.theButton.hidden = false
                                    self.theButton.setImage(img, forState: UIControlState.Normal)
                                    self.imgString = decodedData
                                    // print("= = request and save in Cache = =")
                                }
                            }
                            else
                            {
                                self.textInCell.frame.size.height = 140
                                self.theButton.hidden = true
                            }
                    })
                }
                else
                {
                    let decodedData = NSData(base64EncodedString: post.smallImage, options: NSDataBase64DecodingOptions(rawValue:0))
                    self.theButton.hidden = false
                    let img = UIImage(data: decodedData!)!
                    self.theButton.setImage(img, forState: UIControlState.Normal)
                    self.smallImgString = decodedData
                    let address = self.imageReadZone + "/" + post.postKey
                    self.imgAddress = address
                    
                }
                // } new image  ======   ======   ====== END
            }
            else
            {
                self.textInCell.frame.size.height = 140
                self.theButton.hidden = true
                if post.time != ""
                {
                    self.textInCell.text = post.time + "\n" + post.postDescription
                }
                else
                {
                    self.textInCell.text = post.postDescription
                }
      
            }
            
        }// end of configureCell
        
        
        @IBAction func zoomButton(sender: UIButton)
        {
            if NSUserDefaults.standardUserDefaults().objectForKey(self.imgAddress!) == nil
            {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0))
                    {
                        [unowned self] in
                        
                        DataService.ds.GMBP_IMAGE.childByAppendingPath(self.imgAddress).observeSingleEventOfType(.Value, withBlock:
                            {   snapshot in
                                if snapshot.hasChild("imageString")
                                {
                                    if let data = snapshot.value.objectForKey("imageString") as! String?
                                    {
                                        let decodedData = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions(rawValue:0))
                                        self.imgString = decodedData
                                        NSUserDefaults.standardUserDefaults().setObject(decodedData, forKey: self.imgAddress!)
                                        print("= = image request at \(self.imgAddress) and save in Cache = =")
                                    }
                                }
                                
                        })
                        
                }
            }
            
            
            NSUserDefaults.standardUserDefaults().setObject(self.imgAddress, forKey: "imgAddress")

        }
        
        
        
        
        
        
}