//
//  Category.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 15/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Category {
    
    let id: String!
    let name: String!
    
    var topFreeApplicationsURL: NSURL?
    
    var subcategories: [Category]?
    
    init(json: JSON) {
        
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        
        if let url = json["url"].string {
            self.topFreeApplicationsURL = NSURL(string: url)
        }
        
        if let subgenres = json["subgenres"].array {
            for genres in subgenres {
                //TODO: implement.
            }
        }
        
    }
    
}