//
//  GradientView.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 09/03/25.
//

import UIKit

final class GradientView: UIView {
   
   //MARK: Initialization
   override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .clear
   }

   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   //MARK: Draw Radial Gradient
   override func draw(_ rect: CGRect) {
      let traits = UITraitCollection.current
      let color: CGFloat = traits.userInterfaceStyle == .light ? 0.314 : 1
      
      let components: [CGFloat] = [
         color, color, color, 0.2,
         color, color, color, 0.4,
         color, color, color, 0.6,
         color, color, color, 0.8,
      ]
      
      let locations: [CGFloat] = [0, 0.5, 0.75, 1]
      
      guard let gradient = CGGradient(
         colorSpace: CGColorSpaceCreateDeviceRGB(),
         colorComponents: components,
         locations: locations,
         count: 4
      ) else { return }
      
      let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
      let radius = max(bounds.midX, bounds.midY)
      
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context
         .drawRadialGradient(
            gradient,
            startCenter: centerPoint,
            startRadius: 0,
            endCenter: centerPoint,
            endRadius: radius,
            options: .drawsAfterEndLocation
         )
   }
}
