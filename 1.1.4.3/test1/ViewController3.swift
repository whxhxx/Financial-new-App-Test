//
//  ViewController3.swift
//  test1
//
//  Created by WangHaixin on 12/8/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//
import UIKit
import Firebase

class ViewController3: UIViewController,UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate
{

        let database = DataService.ds.GMBP_ZONE2 as Firebase!
        @IBOutlet weak var tableView: UITableView!
        var posts = [Post]()
        var postsAtHead = [Post]()
        var postsAtFoot = [Post]()
        var loadMoreCount : UInt = 5
        var viewDidLoadloadCount : UInt = 5
        
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var moreButton: UIBarButtonItem!
        @IBOutlet weak var titleButton: UIButton!
        
        //12-3 refresh
        var tableVC = UITableViewController()
        var spinnerH = UIRefreshControl()
        var spinnerF: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        
        //bottom loading
        let threshold = -55.0 // threshold from bottom of tableView
        var isLoadingMore = false // flag
    
    // ------------------------------------------------------- more btn
    @IBAction func moreButtonPressed(sender: UIBarButtonItem)
    {
        self.performSegueWithIdentifier("showPopoverSegue3", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showPopoverSegue3"
        {
            let vc = segue.destinationViewController
            vc.modalPresentationStyle = .Popover
            vc.preferredContentSize = CGSizeMake(310, 125)  //弹出窗口尺寸
            
            let controller = vc.popoverPresentationController
            if controller != nil
            {
                controller?.delegate = self
                controller?.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.4)
                controller?.barButtonItem = self.moreButton
                controller?.permittedArrowDirections = UIPopoverArrowDirection.Up;
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }
    //------------------------------------------------------ more btn END
    
//    override func viewDidAppear(animated: Bool)
//    {
//        if self.tabBarController?.selectedIndex == 2
//        {
//            ViewController1.b3.removeFromSuperview()
//        }
//        
//    }
    
    
        func scrollViewDidScroll(scrollView: UIScrollView)
        {
            let contentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
            /*
            this is bottom refresh trigger !
            */
            if !isLoadingMore && ( Double.init(maximumOffset - contentOffset) < threshold)
            {
                self.isLoadingMore = true
                dispatch_async(dispatch_get_main_queue())
                    {
                        self.loadMoreData() //  * func *
                        self.tableView.reloadData()
                        self.isLoadingMore = false
                }
            }
        }
        
        func didRefreshList()
        {
            //badge update
           self.updateBadgeAndLabelNumber("All posts updated")
           
            self.updatePostOfNumbers(loadMoreCount)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let dateInFormat = dateFormatter.stringFromDate(NSDate())
            
            self.tableVC.tableView.reloadData()
            self.spinnerH.attributedTitle = NSAttributedString(string: "Lasted updated on \(dateInFormat)")
            self.spinnerH.endRefreshing()
        }
    
    func updateBadgeAndLabelNumber(message:String)
    {
        self.database.observeSingleEventOfType(.Value, withBlock:
            {   snapshot in
                ViewController1.zone3Amout = snapshot.childrenCount
                 if var part3 = NSUserDefaults.standardUserDefaults().objectForKey("zone3Amount") as? UInt
                {
                    if(part3 > ViewController1.zone3Amout)
                    {
                        part3 = ViewController1.zone3Amout
                        print("PART3<VC1.ZONE1AMOUNT")
                    }
                    let dif = String(ViewController1.zone3Amout - part3)
                    switch dif
                    {
                    case "0":
                        if message != ""
                        {
                            self.updateLabel.text = message
                            UIView.animateWithDuration(2)
                                { () -> Void in
                                    self.updateLabel.alpha = 1
                                    self.updateLabel.alpha = 0
                            }
                        }
                        break
                    case "1":
                        self.updateLabel.text = String(ViewController1.zone3Amout - part3) + " new post updated"
                        UIView.animateWithDuration(2)
                            { () -> Void in
                                self.updateLabel.alpha = 1
                                self.updateLabel.alpha = 0
                        }
                        break
                    default:
                        self.updateLabel.text = String(ViewController1.zone3Amout - part3) + " new posts updated"
                        UIView.animateWithDuration(2)
                            { () -> Void in
                                self.updateLabel.alpha = 1
                                self.updateLabel.alpha = 0
                        }
                        break
                    }
                    
                }
                
                NSUserDefaults.standardUserDefaults().setObject(ViewController1.zone3Amout, forKey: "zone3Amount")
                ViewController1.b3.removeFromSuperview()
                ViewController1.iconBadge3 = 0
                ViewController1.application.applicationIconBadgeNumber = Int(ViewController1.iconBadge1) +  Int(ViewController1.iconBadge2) +  Int(ViewController1.iconBadge3) +  Int(ViewController1.iconBadge4) +  Int(ViewController1.iconBadge5)
        })
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.updateBadgeAndLabelNumber("")
        self.updatePostOfNumbers(loadMoreCount)

    }
    func updatePostOfNumbers(number:UInt)
    {
        //  OBSERVER to get new data for first time loading ; data list is : snapshot
        database.queryOrderedByValue().queryLimitedToLast(number).observeSingleEventOfType(.Value, withBlock:
            {   snapshot in
                self.posts = []
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
                {
                    for snap in snapshots
                    {
                        //  save each node in database to posts as Dictionary
                        if let postDict = snap.value as? Dictionary<String,AnyObject>
                        {
                            let key = snap.key
                            let aPost = Post(postKey: key, dictionary: postDict)
                            self.posts.append(aPost)
                        }
                    }
                }
                self.tableView.reloadData()
        })
        // end of OBSERVER
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate =  self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 470
            
            //12-3 refresh
            //footer   -------
            tableVC.tableView = self.tableView
            spinnerF.startAnimating()
            spinnerF.color = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            spinnerF.frame = CGRectMake(0, 0, 320, 44)
            self.tableView.tableFooterView = spinnerF
            
            // header
            tableVC.refreshControl = self.spinnerH
            
            self.spinnerH.addTarget(self, action: "didRefreshList", forControlEvents: UIControlEvents.ValueChanged)
            
            // 12.21
            self.updateBadgeAndLabelNumber("All posts updated")
            
            
            self.updatePostOfNumbers(viewDidLoadloadCount)
            
            //end of observer
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("checkNet"), userInfo: nil, repeats: true)
        }//  viewDidLoad  √
    
    
    func checkNet()
    {
        // do your task
        if(Reachability.reachCheck.isConnectedToNetwork())
        {
//            print(" has net")
            titleButton.setTitle("BPIA", forState: UIControlState.Normal)
            titleButton.setTitleColor(UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0) , forState: UIControlState.Normal)
        }
        else
        {
//            print("no net")
            titleButton.setTitle("BPIA (Disconnected)", forState: UIControlState.Normal)
            titleButton.setTitleColor(UIColor(red: 0.84 , green: 0.5, blue: 0.0, alpha: 1.0) , forState: UIControlState.Normal)
        }
    }
    
        func loadMoreData()
        {
            // oberser to get new data
            loadMoreCount+=5
            self.database.queryOrderedByValue().queryLimitedToLast(loadMoreCount).observeSingleEventOfType(.Value, withBlock:
                {   snapshot in
                    self.postsAtFoot = []
                    if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
                    {
                        for snap in snapshots
                        {
                           // print("snap:\(snap)")
                            if let postDict = snap.value as? Dictionary<String,AnyObject>
                            {
                                let key = snap.key
                                let aPost = Post(postKey: key, dictionary: postDict)
                                self.postsAtFoot.append(aPost)
                            }
                            
                        }
                    }
                    
                    self.posts = self.postsAtFoot
                    self.tableView.reloadData()
                    
            })
            //end of observer
            print("loadMore here")
        }
    
     //scroll to top
    @IBAction func scrollToTop(sender: UIButton)
    {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)

    }
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int
        {
            return 1
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return posts.count
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
        {
            let post = posts[posts.count - 1 - indexPath.row]
            if post.text == "y"
            {
                return 200
            }
            else
            {
                return tableView.estimatedRowHeight
            }
            
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        {
            let post = posts[posts.count - 1 - indexPath.row]
           // print(post.postDescription)
            
            if let cell = tableView.dequeueReusableCellWithIdentifier("Cell3")  as? Cell3
            {
                
                cell.configureCell(post)
                
                return cell
            }
            else
            {
                return Cell3()
            }
            
            
            
        }
        
        @IBAction func unwindSecondView(segue: UIStoryboardSegue)
        {
            
        }
    @IBAction func unwindFromExtraView(segue: UIStoryboardSegue)
    {
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showPopoverSegue3", sender: nil)
        }
        if !segue.sourceViewController.isBeingDismissed()
        {
            segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    
        
        
}//end of viewcontroller