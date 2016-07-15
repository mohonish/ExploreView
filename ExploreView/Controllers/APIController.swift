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
    
    public func fetchExploreContent(url: String, completion: () -> Void) {
        
        Alamofire.request(.GET, url).responseJSON { (response) in
            
            if let responseJSON = response.result.value {
                print("FetchExploreContent: Success! \(responseJSON)")
            } else {
                print("FetchExploreContent: Error!")
            }
            
        }
        
    }
    
}