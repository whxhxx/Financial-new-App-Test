//
//  DataService.swift
//  test1
//
//  Created by WangHaixin on 11/2/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//

import Foundation
import Firebase

class DataService
{
    
    static let ds  = DataService()
   
    static let name = "showcase1"
    
    private var _GMBP_USERS = Firebase(url: "https://" + name + ".firebaseio.com/users")
    private var _GMBP_IMAGE = Firebase(url: "https://" + name + ".firebaseio.com/image")
    
    private var _GMBP_BASE  = Firebase(url: "https://" + name + ".firebaseio.com")
    private var _GMBP_ZONE1 = Firebase(url: "https://" + name + ".firebaseio.com/zone1")
    private var _GMBP_ZONE2 = Firebase(url: "https://" + name + ".firebaseio.com/zone2")
    private var _GMBP_ZONE3 = Firebase(url: "https://" + name + ".firebaseio.com/zone3")
    private var _GMBP_ZONE4 = Firebase(url: "https://" + name + ".firebaseio.com/zone4")
    private var _GMBP_ZONE5 = Firebase(url: "https://" + name + ".firebaseio.com/zone5")
    private var _GMBP_ZONE6 = Firebase(url: "https://" + name + ".firebaseio.com/zone6")
    private var _GMBP_ZONE7 = Firebase(url: "https://" + name + ".firebaseio.com/zone7")
    private var _GMBP_ZONE8 = Firebase(url: "https://" + name + ".firebaseio.com/zone8")
    private var _GMBP_ZONE9 = Firebase(url: "https://" + name + ".firebaseio.com/zone9")
    private var _GMBP_ZONE10 = Firebase(url: "https://" + name + ".firebaseio.com/zone10")
    
    private var _GMBP_ZONE11 = Firebase(url: "https://" + name + ".firebaseio.com/zonebpis")
    private var _GMBP_ZONE12 = Firebase(url: "https://" + name + ".firebaseio.com/zone12")
    private var _GMBP_ZONE13 = Firebase(url: "https://" + name + ".firebaseio.com/zone13")
    private var _GMBP_ZONE14 = Firebase(url: "https://" + name + ".firebaseio.com/zone14")
    private var _GMBP_ZONE15 = Firebase(url: "https://" + name + ".firebaseio.com/zone15")
    private var _GMBP_ZONE16 = Firebase(url: "https://" + name + ".firebaseio.com/zone16")
    private var _GMBP_ZONE17 = Firebase(url: "https://" + name + ".firebaseio.com/zone17")
    private var _GMBP_ZONE18 = Firebase(url: "https://" + name + ".firebaseio.com/zone18")
    private var _GMBP_ZONE19 = Firebase(url: "https://" + name + ".firebaseio.com/zone19")
    private var _GMBP_ZONE20 = Firebase(url: "https://" + name + ".firebaseio.com/zone20")
    
    private var _GMBP_FEEDBACK = Firebase(url: "https://" + name + ".firebaseio.com/feedback")

    
    var GMBP_ZONE11: Firebase
        {return _GMBP_ZONE11 }
    var GMBP_ZONE12: Firebase
        {return _GMBP_ZONE12 }
    var GMBP_ZONE13: Firebase
        {return _GMBP_ZONE13 }
    var GMBP_ZONE14: Firebase
        {return _GMBP_ZONE14 }
    var GMBP_ZONE15: Firebase
        {return _GMBP_ZONE15 }
    var GMBP_ZONE16: Firebase
        {return _GMBP_ZONE16 }
    var GMBP_ZONE17: Firebase
        {return _GMBP_ZONE17 }
    var GMBP_ZONE18: Firebase
        {return _GMBP_ZONE18 }
    var GMBP_ZONE19: Firebase
        {return _GMBP_ZONE19 }
    var GMBP_ZONE20: Firebase
        {return _GMBP_ZONE20 }
    
    
    
    var GMBP_ZONE6: Firebase
        {return _GMBP_ZONE6 }
    var GMBP_ZONE7: Firebase
        {return _GMBP_ZONE7 }
    var GMBP_ZONE8: Firebase
        {return _GMBP_ZONE8 }
    var GMBP_ZONE9: Firebase
        {return _GMBP_ZONE9 }
    var GMBP_ZONE10: Firebase
        {return _GMBP_ZONE10 }
    var GMBP_FEEDBACK: Firebase
        {return _GMBP_FEEDBACK }
    

    var GMBP_BASE: Firebase
        {
            return _GMBP_BASE
        }
    var GMBP_IMAGE: Firebase
        {
            return _GMBP_IMAGE
        }
    
    var GMBP_USERS: Firebase
        {
            return _GMBP_USERS
        }
    var GMBP_ZONE1: Firebase
        {
            return _GMBP_ZONE1
        }
    
    var GMBP_ZONE2: Firebase
        {
            return _GMBP_ZONE2
        }
    
    var GMBP_ZONE3: Firebase
        {
            return _GMBP_ZONE3
        }
    
    var GMBP_ZONE4: Firebase
        {
            return _GMBP_ZONE4
        }
    
    var GMBP_ZONE5: Firebase
        {
            return _GMBP_ZONE5
        }
    
    
    
    // write a new user under database user node
    func createFirebaseUser(id: String,user: Dictionary<String,String>)
    {
        GMBP_USERS.childByAppendingPath(id).setValue(user)
       
    }
    
    

}