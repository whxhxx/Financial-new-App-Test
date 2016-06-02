//
//  Post.swift
//  test1
//
//  Created by WangHaixin on 11/3/15.
//  Copyright © 2015 WangHaixin. All rights reserved.
//

import Foundation

class Post
{
    private var _postDescription: String!   // content text in post
    private var _imageUrl:String?   // image (big)
    private var _postKey:String!    // post node key
    private var _title: String!     // content title in post
    private var _text: String!      // text mode or image mode flag variable
    private var _smallImage: String!    // image(small) for tableview to display
    private var _time:String! //time that uploads
    

     //constructor
    init(description:String, imageUrl:String?,title:String)
    {
        self._postDescription = description
        self._imageUrl = imageUrl
        self._title = title
        self._text = text
        self._time = time
    }
    
    //constructor
    init(postKey: String, dictionary: Dictionary<String,AnyObject>)
    {
        self._postKey = postKey
        if let titletext = dictionary["title"] as? String
        {
            self._title = titletext
        }
        else
        {
            self._title = ""
        }
        
        if let time = dictionary["time"] as? String
        {
            self._time = time
        }
        else
        {
            self._time = ""
        }
        
        if let desc = dictionary["description"] as? String
        {
            self._postDescription = desc
        }
        else
        {
            self._postDescription = ""
        }
        
        if let theText = dictionary["text"] as? String
        {
            self._text = theText
        }
        else
        {
            self._text = ""
        }
        if let sImgae = dictionary["smallImage"] as? String
        {
            self._smallImage = sImgae
        }
        else
        {
            self._smallImage = ""
        }
    }
    
    var time:String
        {
            if _time != ""
            {
                return _time
            }
            else
            {
                return ""
            }
    }
    var smallImage:String
        {
            if _smallImage != ""
            {
                return _smallImage
            }
            else
            {
                return ""
            }
        }
    
    var text:String
        {
            if _text != ""
            {
                return _text
            }
            else
            {
                return ""
            }
        }
    
    var postKey:String
        {
            if _postKey != ""
            {
                return _postKey
            }
            else
            {
                return ""
            }
        }
    
    var title:String
        {
            if _title != ""
            {
                return _title
            }
            else
            {
                return ""
            }
        }
    
    var postDescription:String
        {
            if _postDescription != ""
            {
                return _postDescription
            }
            else
            {
                return ""
            }
        }
    
    var imageUrl: String?
        {
            if _imageUrl != ""
            {
                return _imageUrl
            }
            else
            {
                return  ""
            }
        }
}