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
    
    var titleStackHeight: CGFloat!
    var dividePoint: CGFloat!
    var topLimit = CGFloat(97)
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    //MARK: - Duration
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let containerView = transitionContext.containerView()
        
        let viewSize = fromController!.view.bounds.size
        let titleFrame = CGRectMake(0, 0, viewSize.width, titleStackHeight)
        let topFrame = CGRectMake(0, 0, viewSize.width, dividePoint)
        let bottomFrame = CGRectMake(0, dividePoint, viewSize.width, viewSize.height - dividePoint)
        
        //create snapshots
        let snapshotTitle = fromController?.view.resizableSnapshotViewFromRect(titleFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        let snapshotTop = fromController?.view.resizableSnapshotViewFromRect(topFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        let snapshotBottom = fromController?.view.resizableSnapshotViewFromRect(bottomFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        
        //set snapshot initial positions
        snapshotTitle?.frame = titleFrame
        snapshotTop?.frame = topFrame
        snapshotBottom?.frame = bottomFrame
        
        //remove initial view
        fromController?.view.removeFromSuperview()
        
        //add destination view.
        containerView?.addSubview(toController!.view)
        
        //add snapshots on top of it.
        containerView?.addSubview(snapshotTop!)
        containerView?.addSubview(snapshotBottom!)
        
        //add title stack snapshot.
        containerView?.addSubview(snapshotTitle!)
        
        //set initial states
        toController!.view.alpha = 0.3
        
        //animate
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            var newTopFrame = topFrame
            var newBottomFrame = bottomFrame
            newTopFrame.origin.y -= topFrame.size.height - (self.titleStackHeight) - 25
            newBottomFrame.origin.y += bottomFrame.size.height
            
            snapshotTop?.frame = newTopFrame
            snapshotBottom?.frame = newBottomFrame
            
            toController?.view.alpha = 1
            
            }, completion: { (finished) in
                
                snapshotTitle?.removeFromSuperview()
                snapshotTop?.removeFromSuperview()
                snapshotBottom?.removeFromSuperview()
                transitionContext.completeTransition(true)
                
        })
        
    }
    
}