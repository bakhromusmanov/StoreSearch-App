//
//  BounceAnimationController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 17/03/25.
//

import UIKit

final class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
   
   func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
      return 0.4
   }
   
   func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
      guard let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else { return }
      
      toView.frame = transitionContext.finalFrame(for: toViewController)
      let containerView = transitionContext.containerView
      containerView.addSubview(toView)
      toView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      
      UIView.animateKeyframes(
         withDuration: transitionDuration(using: transitionContext),
         delay: 0,
         animations: {
            UIView.addKeyframe(
               withRelativeStartTime: 0.0,
               relativeDuration: 0.334,
               animations: {
                  toView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
               })
            
            UIView.addKeyframe(
               withRelativeStartTime: 0.334,
               relativeDuration: 0.333,
               animations: {
                  toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
               })
            
            UIView.addKeyframe(
               withRelativeStartTime: 0.667,
               relativeDuration: 0.333,
               animations: {
                  toView.transform = CGAffineTransform(scaleX: 1, y: 1)
               })
         }, completion: { isFinished in
            transitionContext.completeTransition(isFinished)
         })
   }
}
