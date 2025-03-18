//
//  SlideOutAnimationController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 17/03/25.
//

import UIKit

final class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
   func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
      return 0.3
   }
   
   func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
      
      guard let fromView = transitionContext.view(forKey: .from) else { return }
      let contrainerView = transitionContext.containerView
      contrainerView.addSubview(fromView)
      let duration = transitionDuration(using: transitionContext)
      
      UIView.animate(
         withDuration: duration,
         animations: {
            fromView.center.y -= contrainerView.bounds.size.height
            fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
         },
         completion: { isFinished in
            transitionContext.completeTransition(isFinished)
         })
   }
}
