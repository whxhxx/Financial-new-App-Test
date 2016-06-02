//
//  CellForExtraViews.swift
//  test1
//
//  Created by WangHaixin on 12/7/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//

import UIKit

class CellForExtraViews: UITableViewCell {
 
        var imageReadZone = "zone6"
        @IBOutlet weak var theButton: UIButton!
        
        var theImage = UIImage()
        var imageInCell : UIImageView!
        @IBOutlet weak var  textInCell : UITextView!
        @IBOutlet weak var titleText: UILabel!
        var post :Post!
        var imgString : NSData?
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
            if let readFromLocalMemory = NSUserDefaults.standardUserDefaults().objectForKey("extraZoneNumber")
            {
                
                print("turning to zone\(readFromLocalMemory)")
                switch readFromLocalMemory as! String
                {
                case "6" :
                    self.imageReadZone = "zone6"
                    break
                case "7" :
                    self.imageReadZone = "zone7"
                    break
                case "8" :
                    self.imageReadZone = "zone8"
                    break
                case "9" :
                    self.imageReadZone = "zone9"
                    break
                case "10" :
                    self.imageReadZone = "zone10"
                    break
                case "11" :
                    self.imageReadZone = "zonebpis"
                    break
                case "12" :
                    self.imageReadZone = "zone12"
                    break
                case "13" :
                    self.imageReadZone = "zone13"
                    break
                case "14" :
                    self.imageReadZone = "zone14"
                    break
                case "15" :
                    self.imageReadZone = "zone15"
                    break
                case "16" :
                    self.imageReadZone = "zone16"
                    break
                case "17" :
                    self.imageReadZone = "zone17"
                    break
                case "18" :
                    self.imageReadZone = "zone18"
                    break
                case "19" :
                    self.imageReadZone = "zone19"
                    break
                case "20" :
                    self.imageReadZone = "zone20"
                    break
                    // more cases add here
                    
                default:
                    self.imageReadZone = "zone6"
                }
            }
           
            
            self.post = post
            
            
            
            if post.title != ""
            {
                self.titleText.text = post.title
                self.titleText.lineBreakMode = NSLineBreakMode.ByWordWrapping
                
            }
            
            
            // image mode
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
                // no small image mode( old time uploads)
                if post.smallImage == ""
                {
                    ///
                    let address = self.imageReadZone + "/" + post.postKey
                    self.imgAddress = address
                     ///
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
 
                                }
                            }
                            else
                            {
                                self.textInCell.frame.size.height = 140
                                self.theButton.hidden = true
                            }
                    })
                }
                    // has small image. 
                else
                {
                    // use the smallimage from data base , and load the image in background
                    let decodedData = NSData(base64EncodedString: post.smallImage, options: NSDataBase64DecodingOptions(rawValue:0))
                    self.theButton.hidden = false
                    
                    let img = UIImage(data: decodedData!)!
                    
                    self.theButton.setImage(img, forState: UIControlState.Normal)
                    let address = self.imageReadZone + "/" + post.postKey
                    self.imgAddress = address
                    print("self.imageAdd::\(self.imgAddress)")
                }
                // } //new image  ======   ======   ====== END
            }
            else
            {
                self.textInCell.frame.size.height = 140
                self.theButton.hidden = true
                if post.time != ""
                {
                    self.textInCell.text = post.time +  "\n" + post.postDescription
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
