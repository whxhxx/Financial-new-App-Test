//
//  IntroView.swift
//  test1
//
//  Created by WangHaixin on 12/17/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//

import UIKit
class IntroView: UIViewController
{
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //set the textview starts at the beginning of its frame
        self.automaticallyAdjustsScrollViewInsets = false
    }
        


}
