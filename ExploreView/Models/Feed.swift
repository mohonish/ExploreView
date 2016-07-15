//
//  Feed.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 15/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Feed {
    
    let title: String
    let artist: String
    
    var imageURL: NSURL?
    
    init(json: JSON) {
        self.title = json["im:name"]["label"].stringValue
        self.artist = json["im:artist"]["label"].stringValue
        
        if let urlStr = json["im:image"].dictionary {
            for str in urlStr {
                if let url = str.1["label"].string {
                    self.imageURL = NSURL(string: url)
                }
            }
        }
    }
    
}