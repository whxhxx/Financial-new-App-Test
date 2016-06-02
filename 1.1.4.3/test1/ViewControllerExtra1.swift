//
//  ViewControllerExtra1.swift
//  test1
//
//  Created by WangHaixin on 12/7/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//

// similar to Viewcontroller2

import UIKit
import Firebase

class ViewControllerExtra1 : UIViewController, UITableViewDataSource, UITableViewDelegate
{
        
        // variable -------------------------------------
        @IBOutlet weak var tableView: UITableView!
        var posts = [Post]()
        var postsAtHead = [Post]()
        var postsAtFoot = [Post]()
        var loadMoreCount : UInt = 5
        var ViewDidLoadloadCount : UInt = 5
        var database: Firebase!
        let titleButton =  UIButton(type: UIButtonType.Custom) as UIButton
        var titleString = ""
        
        //12-3 refresh
        var tableVC = UITableViewController()
        var spinnerH = UIRefreshControl()
        var spinnerF: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        
        //bottom loading
        let threshold = -55.0 // threshold from bottom of tableView
        var isLoadingMore = false // flag
    
        @IBOutlet weak var updateLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate =  self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 468
       
        //read saved var from Popover View Controller to see which link is going to
        if let readFromLocalMemory = NSUserDefaults.standardUserDefaults().objectForKey("extraZoneNumber")
        {
            
            print("this is zone\(readFromLocalMemory)")
            switch readFromLocalMemory as! String
            {
            case "6" :
                database = DataService.ds.GMBP_ZONE6
                titleString = "BPR"
                break
                
            case "7" :
                database = DataService.ds.GMBP_ZONE7
                titleString = "BPS"
                break
                
            case "8" :
                database = DataService.ds.GMBP_ZONE8
                titleString = "BPH"
                break
                
            case "9" :
                database = DataService.ds.GMBP_ZONE9
                titleString = "BPA"
                break
                
            case "10" :
                database = DataService.ds.GMBP_ZONE10
                titleString = "BPO"
                break
            case "11" :
                database = DataService.ds.GMBP_ZONE11
                titleString = "BPIS"
                break
            case "12" :
                database = DataService.ds.GMBP_ZONE12
                titleString = "BP12"
                break
            case "13" :
                database = DataService.ds.GMBP_ZONE13
                titleString = "BP13"
                break
            case "14" :
                database = DataService.ds.GMBP_ZONE14
                titleString = "BP14"
                break
            case "15" :
                database = DataService.ds.GMBP_ZONE15
                titleString = "BP15"
                break
            case "16" :
                database = DataService.ds.GMBP_ZONE16
                titleString = "BP16"
                break
            case "17" :
                database = DataService.ds.GMBP_ZONE17
                titleString = "BP17"
                break
            case "18" :
                database = DataService.ds.GMBP_ZONE18
                titleString = "BP18"
                break
            case "19" :
                database = DataService.ds.GMBP_ZONE19
                titleString = "BP19"
                break
            case "20" :
                database = DataService.ds.GMBP_ZONE20
                titleString = "BP20"
                break
                // more cases add here
                
            default:
                database = DataService.ds.GMBP_ZONE6
                titleString = "BPR"
            }
            
            
            titleButton.frame = CGRectMake(0, 0, 80, 40) as CGRect
            titleButton.backgroundColor = UIColor.clearColor()
            titleButton.setTitle(titleString, forState: UIControlState.Normal)
            titleButton.titleLabel?.font = UIFont.boldSystemFontOfSize(24)
            titleButton.setTitleColor(UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0) , forState: UIControlState.Normal)
            
            titleButton.addTarget(self, action: Selector("scrollToTop:"), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.titleView = titleButton
            UIView.animateWithDuration(2)
                { () -> Void in
                    self.updateLabel.alpha = 1
                    self.updateLabel.alpha = 0
            }
            
            
        }
        
        
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
        
        // oberser to get new data
        database.queryOrderedByValue().queryLimitedToLast(ViewDidLoadloadCount).observeSingleEventOfType(.Value, withBlock:
            {   snapshot in
                
                
                self.posts = []
                //array of posts
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
                {
                    
                    for snap in snapshots
                    {
                     //   print("snap:\(snap)")
                        if let postDict = snap.value as? Dictionary<String,AnyObject>
                        {
                            let key = snap.key
                            let aPost = Post(postKey: key, dictionary: postDict)
                            self.posts.append(aPost)
                        }
                        
                    }
                }
                self.tableView.reloadData()
                NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("checkNet"), userInfo: nil, repeats: true)
        })
        //end of observer
    }//  viewDidLoad  √
    
    func checkNet()
    {
        // do your task
        if(Reachability.reachCheck.isConnectedToNetwork())
        {
            //print(" has net")
            titleButton.setTitle(titleString, forState: UIControlState.Normal)
            titleButton.setTitleColor(UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0) , forState: UIControlState.Normal)
        }
        else
        {
           // print("no net")
            titleButton.setTitle(titleString+"(Disconnected)", forState: UIControlState.Normal)
            titleButton.setTitleColor(UIColor(red: 0.84 , green: 0.5, blue: 0.0, alpha: 1.0) , forState: UIControlState.Normal)
        }
    }

    
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
        
            // oberser to get new data
            database.queryLimitedToLast(loadMoreCount).observeSingleEventOfType(.Value, withBlock:
                {   snapshot in
                    
                    self.postsAtHead = []
                    //array of posts
                    if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
                    {
                        for snap in snapshots
                        {
                            print(snap.key)
                         //   print(snap)
                            if let postDict = snap.value as? Dictionary<String,AnyObject>
                            {
                                
                                let key = snap.key
                                let aPost = Post(postKey: key, dictionary: postDict)
                                self.postsAtHead.append(aPost)
                            }
                            
                        }
                    }
                    //                self.postsAtHead = self.postsAtHead + self.posts
                    self.posts = self.postsAtHead
                    
                    self.tableView.reloadData()
                    UIView.animateWithDuration(2)
                        { () -> Void in
                            self.updateLabel.alpha = 1
                            self.updateLabel.alpha = 0
                    }

                    
            })
            //end of observer
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let dateInFormat = dateFormatter.stringFromDate(NSDate())
            
            self.tableVC.tableView.reloadData()
            self.spinnerH.attributedTitle = NSAttributedString(string: "Lasted updated on \(dateInFormat)")
            self.spinnerH.endRefreshing()
        }
        
     //scroll to top
    
    func scrollToTop(button: UIButton)
    {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        

    }
        
        
        
    func loadMoreData()
    {
            // oberser to get new data
            loadMoreCount+=5
            database.queryOrderedByValue().queryLimitedToLast(loadMoreCount).observeSingleEventOfType(.Value, withBlock:
                {   snapshot in
                    self.postsAtFoot = []
                    if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
                    {
                        for snap in snapshots
                        {
                         //   print("snap:\(snap)")
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
            if let cell = tableView.dequeueReusableCellWithIdentifier("CellForExtraViews")  as? CellForExtraViews
            {
                cell.configureCell(post)
                return cell
            }
            else
            {
                return CellForExtraViews()
            }
            
            
            
        }
    
    func back(sender: UIBarButtonItem) {
       
        print("pressed")
        
        performSegueWithIdentifier("backToMainViewsSegue", sender: self)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
        
        @IBAction func unwindSecondView(segue: UIStoryboardSegue)
        {
            //empty here
        }
        
        
        
        
        
        
}//end of viewcontroller
