//
//  MCExploreAnimator.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 15/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import Foundation
import UIKit

class MCExploreAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Class Members
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    //MARK: - Duration
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        //TODO.
        
    }
    
}