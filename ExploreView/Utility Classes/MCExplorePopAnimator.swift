//
//  MCExplorePopAnimator.swift
//  ExploreView
//
//  Created by Mohonish Chakraborty on 15/07/16.
//  Copyright © 2016 mohonish. All rights reserved.
//

import Foundation
import UIKit

class MCExplorePopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Class Members
    
    var lastSectionFrame: CGRect!
    var titleStackHeight: CGFloat!
    var dividePoint: CGFloat!
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    //MARK: - Duration
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let containerView = transitionContext.containerView()
        
        let viewSize = fromController!.view.bounds.size
        
        lastSectionFrame = CGRectMake(0, 0, viewSize.width, 50)
        titleStackHeight = CGFloat(50)
        dividePoint = viewSize.height / 2
        
        let titleFrame = CGRectMake(0, 0, viewSize.width, titleStackHeight - 50)
        let topFrame = CGRectMake(0, 0, viewSize.width, dividePoint)
        let bottomFrame = CGRectMake(0, dividePoint, viewSize.width, viewSize.height - dividePoint)
        
        //create snapshots
        let snapshotOldTitle = fromController?.view.resizableSnapshotViewFromRect(lastSectionFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        let snapshotTitle = fromController?.view.resizableSnapshotViewFromRect(titleFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        let snapshotTop = fromController?.view.resizableSnapshotViewFromRect(topFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        let snapshotBottom = fromController?.view.resizableSnapshotViewFromRect(bottomFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
        
        //set snapshot initial positions
        var newTopFrame = topFrame
        var newBottomFrame = bottomFrame
        newTopFrame.origin.y -= topFrame.size.height - (self.titleStackHeight) - 25
        newBottomFrame.origin.y += bottomFrame.size.height
        
        snapshotTop?.frame = newTopFrame
        snapshotBottom?.frame = newBottomFrame
        
        let newOldTitleFrame = CGRectMake(self.lastSectionFrame.origin.x, self.lastSectionFrame.origin.y, self.lastSectionFrame.width, 25)
        snapshotOldTitle?.frame = newOldTitleFrame
        snapshotTitle?.frame = titleFrame
        
        //remove initial view
        fromController?.view.removeFromSuperview()
        
        //add destination view.
        containerView?.addSubview(toController!.view)
        
        //add snapshots on top of it.
        containerView?.addSubview(snapshotTop!)
        containerView?.addSubview(snapshotBottom!)
        
        //add title stack snapshot.
        containerView?.addSubview(snapshotTitle!)
        
        //add old title snapshot.
        containerView?.addSubview(snapshotOldTitle!)
        
        //set initial states
        toController!.view.alpha = 0.3
        
        //animate
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            snapshotOldTitle?.frame = self.lastSectionFrame
            
            snapshotTop?.frame = topFrame
            snapshotBottom?.frame = bottomFrame
            
            toController?.view.alpha = 1
            
            }, completion: { (finished) in
                
                snapshotOldTitle?.removeFromSuperview()
                snapshotTitle?.removeFromSuperview()
                snapshotTop?.removeFromSuperview()
                snapshotBottom?.removeFromSuperview()
                transitionContext.completeTransition(true)
                
        })
        
    }
    
}