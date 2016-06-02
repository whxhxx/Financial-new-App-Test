//
//   ViewController1.swift
//   test1
// 
//   Created by WangHaixin on 12/8/15.
//   Copyright © 2015 WangHaixin. All rights reserved.
// 

import UIKit
import Firebase

class ViewController1: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPopoverPresentationControllerDelegate
{

    //  vars  -------------------------------------
    let database = DataService.ds.GMBP_ZONE5 as Firebase!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var moreButton: UIBarButtonItem!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    //  vars for top and buttom refresh
    var tableVC = UITableViewController()
    var spinnerH = UIRefreshControl()
    var spinnerF: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var postsAtHead = [Post]()
    var postsAtFoot = [Post]()
    var loadMoreCount : UInt = 5
    var viewDidLoadloadCount : UInt = 5
    
    //  vars for scrollview down to load more (old) data
    //   threshold from bottom of tableView
    let threshold = -55.0
    var isLoadingMore = false
    
    // badge counter:all message in zone and number of message read
    static var zone1Amout = 0      as UInt
    static var zone1UpdataDif = 0 as UInt
    static var zone2Amout = 0      as UInt
    static var zone2UpdateDif = 0 as UInt
    static var zone3Amout = 0      as UInt
    static var zone3UpdataDif = 0 as UInt
    static var zone4Amout = 0      as UInt
    static var zone4UpdateDif = 0 as UInt
    static var zone5Amout = 0      as UInt
    static var zone5UpdateDif = 0 as UInt
    //  create 5 label to be the badge with custom position
    static var b1 : UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/6-10 , 0, 20, 20))
    static var b2 : UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width*2/6+5, 0, 20, 20))
    static var b3 : UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width*3/6+15, 0, 20, 20))
    static var b4 : UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width*4/6+25, 0, 20, 20))
    static var b5 : UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width*6/6-20, 0, 20, 20))
    
 
    static let application = UIApplication.sharedApplication()
    static var iconBadge1 = 0 as UInt
    static var iconBadge2 = 0 as UInt
    static var iconBadge3 = 0 as UInt
    static var iconBadge4 = 0 as UInt
    static var iconBadge5 = 0 as UInt
    

    


    // func to set badge property
    func setBadge(x:UILabel)
    {
        x.layer.cornerRadius = x.bounds.size.height/2
        x.textAlignment = NSTextAlignment.Center
        x.layer.masksToBounds = true
        x.font = UIFont.systemFontOfSize(10)
        x.textColor = UIColor.whiteColor()
        x.backgroundColor = UIColor(red: 0, green: 0.4, blue: 0, alpha: 1)
    }
    
    //  badge listener to listen to the news update
    func badgeListener(zone: Firebase)
    {
        switch zone
        {
        case DataService.ds.GMBP_ZONE5:
            let zone1BadgeLink = DataService.ds.GMBP_ZONE5
            zone1BadgeLink.observeEventType(.Value, withBlock:
            {   snapshot in
                ViewController1.zone1Amout = snapshot.childrenCount
                let part1 = ViewController1.zone1Amout
                var part2 = 0 as UInt
                if NSUserDefaults.standardUserDefaults().objectForKey("zone1Amount") != nil
                {
                    part2 = NSUserDefaults.standardUserDefaults().objectForKey("zone1Amount") as! UInt
                }
                
                if( part1 > part2 )
                {
                    
                    ViewController1.b1.text =  String(part1 - part2)
                    self.tabBarController?.tabBar.addSubview(ViewController1.b1)
                    ViewController1.iconBadge1 = part1 - part2
                }
                else
                {
                    ViewController1.iconBadge1 = 0
                }
            })
            break
            
        case DataService.ds.GMBP_ZONE1:
            let zone2BadgeLink = DataService.ds.GMBP_ZONE1
            zone2BadgeLink.observeEventType(.Value, withBlock:
            {   snapshot in
            ViewController1.zone2Amout = snapshot.childrenCount
            
            let part1 = ViewController1.zone2Amout
            var part2 = 0 as UInt
            if NSUserDefaults.standardUserDefaults().objectForKey("zone2Amount") != nil
            {
                part2 = NSUserDefaults.standardUserDefaults().objectForKey("zone2Amount") as! UInt
            }
            
            if( part1 > part2 )
            {
                 ViewController1.b2.text =  String(part1 - part2)
                self.tabBarController?.tabBar.addSubview(ViewController1.b2)
                ViewController1.iconBadge2 = part1 - part2
            }
            else
            {
                ViewController1.iconBadge2 = 0
                 }
            })
            break
            
        case DataService.ds.GMBP_ZONE2:
            let zone3BadgeLink = DataService.ds.GMBP_ZONE2
            zone3BadgeLink.observeEventType(.Value, withBlock:
            {   snapshot in
                ViewController1.zone3Amout = snapshot.childrenCount
                let part1 = ViewController1.zone3Amout
                var part2 = 0 as UInt
                if NSUserDefaults.standardUserDefaults().objectForKey("zone3Amount") != nil
                {
                    part2 = NSUserDefaults.standardUserDefaults().objectForKey("zone3Amount") as! UInt
                }
                    
                if( part1 > part2 )
                {
                    ViewController1.iconBadge3 = part1 - part2
                    ViewController1.b3.text =  String(part1 - part2)
                    self.tabBarController?.tabBar.addSubview(ViewController1.b3)
                }
                else
                {
                    ViewController1.iconBadge3 = 0
                }
            })
            break
            
        case DataService.ds.GMBP_ZONE3:
            let zone4BadgeLink = DataService.ds.GMBP_ZONE3
            zone4BadgeLink.observeEventType(.Value, withBlock:
            {   snapshot in
                ViewController1.zone4Amout = snapshot.childrenCount
                let part1 = ViewController1.zone4Amout
                var part2 = 0 as UInt
                if NSUserDefaults.standardUserDefaults().objectForKey("zone4Amount") != nil
                {
                    part2 = NSUserDefaults.standardUserDefaults().objectForKey("zone4Amount") as! UInt
                }
                    
                    
                if( part1 > part2 )
                {
                    ViewController1.b4.text =  String(part1 - part2)
                    self.tabBarController?.tabBar.addSubview(ViewController1.b4)
                    ViewController1.iconBadge4 = part1 - part2
                }
                else
                {
                    ViewController1.iconBadge4 = 0                     }
            })
            break
            
        case DataService.ds.GMBP_ZONE4:
            let zone5BadgeLink = DataService.ds.GMBP_ZONE4
            zone5BadgeLink.observeEventType(.Value, withBlock:
            {   snapshot in
                ViewController1.zone5Amout = snapshot.childrenCount
                
                let part1 = ViewController1.zone5Amout
                var part2 = 0 as UInt
                if NSUserDefaults.standardUserDefaults().objectForKey("zone5Amount") != nil
                {
                    part2 = NSUserDefaults.standardUserDefaults().objectForKey("zone5Amount") as! UInt
 
                }
                
                if( part1 > part2 )
                {
                     ViewController1.b5.text =  String(part1 - part2)
                    self.tabBarController?.tabBar.addSubview(ViewController1.b5)
                    ViewController1.iconBadge5 = part1 - part2
                }
                else
                {
                    ViewController1.iconBadge5 = 0                     }
                })
            break
        
        
        default: break
        
        }
    }
    
    func updateBadgeAndLabelNumber(message:String)
    {
        self.database.observeSingleEventOfType(.Value, withBlock:  // 1. check online number
            {   snapshot in
                ViewController1.zone1Amout = snapshot.childrenCount
                if var part3 = NSUserDefaults.standardUserDefaults().objectForKey("zone1Amount") as? UInt  // 2.compare local number
                {
                    if(part3 > ViewController1.zone1Amout)
                    {
                        part3 = ViewController1.zone1Amout
                        print("PART3<VC1.ZONE1AMOUNT")
                    }
                    let dif = String(ViewController1.zone1Amout - part3)
                    switch dif                                          // 3.display
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
                        self.updateLabel.text = String(ViewController1.zone1Amout - part3) + " new post updated"
                        UIView.animateWithDuration(2)
                            { () -> Void in
                                self.updateLabel.alpha = 1
                                self.updateLabel.alpha = 0
                        }
                        break
                    default:
                        self.updateLabel.text = String(ViewController1.zone1Amout - part3) + " new posts updated"
                        UIView.animateWithDuration(2)
                            { () -> Void in
                                self.updateLabel.alpha = 1
                                self.updateLabel.alpha = 0
                        }
                        break
                    }
                    
                }                                   // 4. update VC1.zone1amount
                                                    // 5. remove badge
                
                NSUserDefaults.standardUserDefaults().setObject(ViewController1.zone1Amout, forKey: "zone1Amount")
                ViewController1.b1.removeFromSuperview()
                ViewController1.iconBadge1 = 0
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
 
    /*
    viewDidLoad runs when this view loads( which means most time it runs earlier than others)
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate =  self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 570
        
        // refresh part -------------------------------------------
        //  header refresher -- -- --
        tableVC.refreshControl = self.spinnerH
        // when headr refresher runs, it triggers function: didRefreshList
        self.spinnerH.addTarget(self, action: "didRefreshList", forControlEvents: UIControlEvents.ValueChanged)
            
        // footer refresher  -- -- --
        tableVC.tableView = self.tableView
        spinnerF.startAnimating()
        spinnerF.color = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        spinnerF.frame = CGRectMake(0, 0, 320, 44)
        self.tableView.tableFooterView = spinnerF
            
        // badges
        setBadge(ViewController1.b1)
        setBadge(ViewController1.b2)
        setBadge(ViewController1.b3)
        setBadge(ViewController1.b4)
        setBadge(ViewController1.b5)
            
        self.badgeListener(DataService.ds.GMBP_ZONE5)
        self.badgeListener(DataService.ds.GMBP_ZONE1)
        self.badgeListener(DataService.ds.GMBP_ZONE2)
        self.badgeListener(DataService.ds.GMBP_ZONE3)
        self.badgeListener(DataService.ds.GMBP_ZONE4)
        
       
        // 12.21 check number for now
        self.updateBadgeAndLabelNumber("All posts updated")
     

        //  OBSERVER to get new data for first time loading ; data list is : snapshot
       self.updatePostOfNumbers(viewDidLoadloadCount)
        
        // end of OBSERVER
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("checkNet"), userInfo: nil, repeats: true)
    }
    
   
   


    
    
        /*
        this func triggered when the top is pull-down for load
        */
    func didRefreshList()
    {
        self.updateBadgeAndLabelNumber("All posts updated")
        
 
        /* then OBSERVER to get new data ( data number is : loadMoreCount )
            From GMBP_ZONE1 as var of ds in class DataService
        */
//        database.queryLimitedToLast(loadMoreCount).observeSingleEventOfType(.Value, withBlock:
//        {   snapshot in
//            self.postsAtHead = []
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
//            {
//                for snap in snapshots
//                {
//                     if let postDict = snap.value as? Dictionary<String,AnyObject>
//                    {
//                        let key = snap.key
//                        let aPost = Post(postKey: key, dictionary: postDict)
//                        self.postsAtHead.append(aPost)
//                    }
//                            
//                }
//            }
//            self.posts = self.postsAtHead
//            //  reload data of the tableview
//            self.tableView.reloadData()
//        })
        // end of OBSERVER
        self.updatePostOfNumbers(loadMoreCount)
        ///
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateInFormat = dateFormatter.stringFromDate(NSDate())
            
        self.tableVC.tableView.reloadData()
        self.spinnerH.attributedTitle = NSAttributedString(string: "Lasted updated on \(dateInFormat)")
        self.spinnerH.endRefreshing()
    }
    
    
    // func: check network connection
    func checkNet()
    {
        if(Reachability.reachCheck.isConnectedToNetwork())
        {
            titleButton.setTitle("BP", forState: UIControlState.Normal)
            titleButton.setTitleColor(UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0) , forState: UIControlState.Normal)
        }
        else
        {
            titleButton.setTitle("BP (Disconnected)", forState: UIControlState.Normal)
            titleButton.setTitleColor(UIColor(red: 0.84 , green: 0.5, blue: 0.0, alpha: 1.0) , forState: UIControlState.Normal)
        }
    }
    
    
    /*
    this func is to load more data(number = loadMoreCount) each time
    */
    func loadMoreData()
    {
        //  oberser to get new data
        loadMoreCount+=5
        database.queryOrderedByValue().queryLimitedToLast(loadMoreCount).observeSingleEventOfType(.Value, withBlock:
        {   snapshot in
            self.postsAtFoot = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
            {
                for snap in snapshots
                {
                    //  print("snap:\(snap)")
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
        //  end of observer
    }
    
    //  scroll to top
    @IBAction func scrollToTop(sender: UIButton)
    {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    //  function runs when pull up at bottom
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        /*
        this is bottom refresh trigger ! when pull-up length over threshold
        */
        if !isLoadingMore && ( Double.init(maximumOffset - contentOffset) < threshold)
        {
            self.isLoadingMore = true
            dispatch_async(dispatch_get_main_queue())
                {
                    //   * func * load more data
                    self.loadMoreData()
                    self.tableView.reloadData()
                    self.isLoadingMore = false
                }
        }
    }
    
    //  ------------------------------------------------------- more btn
    @IBAction func moreButtonPressed(sender: UIBarButtonItem)
    {
        self.performSegueWithIdentifier("showPopoverSegue1", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showPopoverSegue1"
        {
            let vc = segue.destinationViewController
            vc.modalPresentationStyle = .Popover
            vc.preferredContentSize = CGSizeMake(310, 125)  // 弹出窗口尺寸
            
            
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
    // ------------------------------------------------------ more btn END
    
    //  default function
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
        
    //  default function: cell number of the tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
        
    //  cell height depends on content type: y for only text, n for image
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
       
        //1.1.3 fixed the height for long text
            return tableView.estimatedRowHeight
    
    }
        
    // default func: to define the cell which the tableview will use
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let post = posts[posts.count - 1 - indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell1")  as? Cell1
        {
            cell.configureCell(post)
            return cell
        }
        else
        {
            return Cell1()
        }
    }
        
    //  As a mark function for Item view to return
    @IBAction func unwindSecondView(segue: UIStoryboardSegue)
    {
    // empty here
    }
        
    @IBAction func unwindFromExtraView(segue: UIStoryboardSegue)
    {
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
             self.performSegueWithIdentifier("showPopoverSegue1", sender: nil)
        }
        
        if !segue.sourceViewController.isBeingDismissed()
        {
            segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    
        
}// end of All
