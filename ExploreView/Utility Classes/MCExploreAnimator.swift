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
        
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let containerView = transitionContext.containerView()
        
        let viewSize = fromController!.view.bounds.size
        let topFrame = CGRectMake(0, 0, viewSize.width, viewSize.height/2)
        let bottomFrame = CGRectMake(0, viewSize.height/2, viewSize.width, viewSize.height/2)
        
        //create snapshots
        let snapshotTop = fromController?.view.resizableSnapshotViewFromRect(topFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        let snapshotBottom = fromController?.view.resizableSnapshotViewFromRect(bottomFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        //set snapshot initial positions
        snapshotTop?.frame = topFrame
        snapshotBottom?.frame = bottomFrame
        
        //remove initial view
        fromController?.view.removeFromSuperview()
        
        //add destination view.
        containerView?.addSubview(toController!.view)
        
        //add snapshots on top of it.
        containerView?.addSubview(snapshotTop!)
        containerView?.addSubview(snapshotBottom!)
        
        //animate
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 10.0, options: .CurveEaseIn, animations: {
            
            var newTopFrame = topFrame
            var newBottomFrame = bottomFrame
            newTopFrame.origin.y -= topFrame.size.height
            newBottomFrame.origin.y += bottomFrame.size.height
            
            snapshotTop?.frame = newTopFrame
            snapshotBottom?.frame = newBottomFrame
            
            }, completion: { (finished) in
                
                snapshotTop?.removeFromSuperview()
                snapshotBottom?.removeFromSuperview()
                transitionContext.finishInteractiveTransition()
        })
        
        
        
    }
    
}