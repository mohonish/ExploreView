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
    
    var dividePoint: CGFloat!
    var topLimit = CGFloat(97)
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    //MARK: - Duration
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 15
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let containerView = transitionContext.containerView()
        
        let viewSize = fromController!.view.bounds.size
        let topFrame = CGRectMake(0, 0, viewSize.width, dividePoint)
        let bottomFrame = CGRectMake(0, dividePoint, viewSize.width, viewSize.height - dividePoint)
        
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
        toController!.view.alpha = 0.3
        
        //add snapshots on top of it.
        containerView?.addSubview(snapshotTop!)
        containerView?.addSubview(snapshotBottom!)
        
        //animate
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            var newTopFrame = topFrame
            var newBottomFrame = bottomFrame
            newTopFrame.origin.y -= (topFrame.size.height - self.topLimit)
            newBottomFrame.origin.y += bottomFrame.size.height
            
            snapshotTop?.frame = newTopFrame
            snapshotBottom?.frame = newBottomFrame
            
            toController?.view.alpha = 1
            
            }, completion: { (finished) in
                
                snapshotTop?.removeFromSuperview()
                snapshotBottom?.removeFromSuperview()
                transitionContext.completeTransition(true)
                
        })
        
    }
    
}