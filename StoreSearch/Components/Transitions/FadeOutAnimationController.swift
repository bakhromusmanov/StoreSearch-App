//
//  FadeOutAnimationController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 19/03/25.
//

import UIKit

final class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
   func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
      return 0.3
   }
   
   func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
      guard let fromView = transitionContext.view(forKey: .from) else { return }
      
      UIView.animate(
         withDuration: transitionDuration(using: transitionContext),
         animations: {
            fromView.alpha = 0
         },
         completion: { isFinished in
            transitionContext.completeTransition(isFinished)
         })
   }
}
