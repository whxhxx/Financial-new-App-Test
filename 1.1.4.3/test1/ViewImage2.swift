//
//  ViewImage2.swift
//  test1
//
//  Created by WangHaixin on 12/16/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//

import Foundation
import UIKit

class ViewImage2 : UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    var img : UIImage?
    var imageView = UIImageView()
    var imgString: NSData?
    
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    // not in use
    @IBAction func btnDismiss(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // remove local image memery when leaving
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
 
    }
    
    override func viewDidLoad()
    {

    }
    
    @IBAction func saveImage(sender: UIButton)
    {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func imgSetup()
    {
        img = UIImage(data: imgString!)
        imageView.image = img
        imageView.userInteractionEnabled = true
        
        imageView.contentMode = UIViewContentMode.Center
        
        imageView.frame = CGRectMake(0, 0, img!.size.width, img!.size.height)
        
        self.scrollView.addSubview(imageView)
        
        scrollView.contentSize = img!.size
        
        let scrollViewFrame = scrollView.frame
        
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        
        let minScale = min(scaleHeight,scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        
        scrollView.maximumZoomScale = 3
        
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        
    }
    
    //runs when the view appears
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        scrollView.delegate = self
        
        //read local memory for image
        
        let address =  NSUserDefaults.standardUserDefaults().objectForKey("imgAddress") as! String
        print(address)
        var localImgData : NSData? = nil
        if NSUserDefaults.standardUserDefaults().objectForKey(address) != nil
        {
            localImgData =  NSUserDefaults.standardUserDefaults().objectForKey(address) as? NSData

            
        }
        // put image into a scroll view for zooming
        if localImgData != nil
        {
            print("第二幕2: 有图 from BTN")
            self.actIndicator.hidden = true
            self.actIndicator.startAnimating()
            self.imgString = localImgData
            imgSetup()
            self.actIndicator.stopAnimating()
        }
        else
        {
            self.actIndicator.hidden = false
            self.actIndicator.startAnimating()
            print("第二幕2：无图 正在下载")
             print(address)
            DataService.ds.GMBP_IMAGE.childByAppendingPath(address).observeSingleEventOfType(.Value, withBlock:
                {   snapshot in
                    if snapshot.hasChild("imageString")
                    {
                        if let data = snapshot.value.objectForKey("imageString") as! String?
                        {
                            let decodedData = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions(rawValue:0))
                            self.imgString = decodedData
                            self.imgSetup()
                            self.actIndicator.hidden = true
                            self.actIndicator.stopAnimating()
                            print("图找到了")

                        }
                    }
            })
        }
    }
    
    func centerScrollViewContents()
    {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        if contentsFrame.size.width < boundsSize.width
        {
            contentsFrame.origin.x = ( boundsSize.width - contentsFrame.size.width) / 2
            
        }
        else
        {
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height
        {
            contentsFrame.origin.y = ( boundsSize.height - contentsFrame.size.height) / 2
            
        }
        else
        {
            contentsFrame.origin.y = 0
        }
        
        imageView.frame = contentsFrame
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.sharedApplication().statusBarOrientation
            
            switch orient {
            case .Portrait:
                //  print("Portrait")
                // Do something
                let boundsSize = self.scrollView.bounds.size
                var contentsFrame = self.imageView.frame
                if contentsFrame.size.width < boundsSize.width
                {
                    contentsFrame.origin.x = ( boundsSize.width - contentsFrame.size.width) / 2
                    
                }
                else
                {
                    contentsFrame.origin.x = 0
                }
                
                if contentsFrame.size.height < boundsSize.height
                {
                    contentsFrame.origin.y = ( boundsSize.height - contentsFrame.size.height) / 2
                }
                else
                {
                    contentsFrame.origin.y = 0
                }
                
                
                self.imageView.frame = contentsFrame
                
                
                
                
                
                
                
                
                
            default:
                 print("Landscape")
                // Do something else
                let boundsSize = self.scrollView.bounds.size
                var contentsFrame = self.imageView.frame
                if contentsFrame.size.width < boundsSize.width
                {
                    contentsFrame.origin.x = ( boundsSize.width - contentsFrame.size.width) / 2
                    
                }
                else
                {
                    contentsFrame.origin.x = 0
                }
                
                if contentsFrame.size.height < boundsSize.height
                {
                    contentsFrame.origin.y = ( boundsSize.height - contentsFrame.size.height) / 2
                }
                else
                {
                    contentsFrame.origin.y = 0
                }
                
                  self.imageView.frame = contentsFrame
                 
               
                 
                let scaleWidth =  boundsSize.width / contentsFrame.size.width
                
                let scaleHeight = boundsSize.height / contentsFrame.size.height
                 
                let minScale = min(scaleHeight,scaleWidth)
                 print(minScale)
                self.scrollView.zoomScale = 0.5
                
                
            }
            
            }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
                // print("rotation completed")
        })
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView)
    {
        centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
    
    
    
    
    
    
    
    
    
    
    
}