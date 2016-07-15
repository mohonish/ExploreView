//
//  APIController.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 15/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class APIController {
    
    static let sharedInstance = APIController()
    
    public func fetchExploreContent(url: String, completion: (category: Category?) -> Void) {
        
        Alamofire.request(.GET, url).responseJSON { (response) in
            
            if let responseJSON = response.result.value {
                print("FetchExploreContent: Success!")
                
                let json = JSON(responseJSON)
                
                let dict = json.dictionary
                print(dict?.count)
                for x in dict! {
                    let category = Category(json: x.1)
                    completion(category: category)
                    return
                }
                
            } else {
                print("FetchExploreContent: Error!")
            }
            
            completion(category: nil)
            return
            
        }
        
    }
    
    public func fetchFeed(url: String, completion: (feed: [Feed]?) -> Void) {
        
        Alamofire.request(.GET, url).responseJSON { (response) in
            
            if let responseJSON = response.result.value {
                print("fetchFeed: Success!")
                
                let json = JSON(responseJSON)
                
                var feedItems = [Feed]()
                
                if let arr = json["feed"]["entry"].array {
                    for x in arr {
                        let thisFeed = Feed(json: x)
                        feedItems.append(thisFeed)
                    }
                }
                
                completion(feed: feedItems)
                return
                
            } else {
                print("fetchFeed: Error!")
            }
            
            completion(feed: nil)
            return
            
        }
        
    }
    
}