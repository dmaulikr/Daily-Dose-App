//
//  UIBezierPath+SemiCircle.swift
//  Daily Dose
//
//  Created by Elliot Catalano on 4/8/17.
//  Copyright © 2017 Elliot Catalano. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    convenience init(semiCircle centre:CGPoint, radius:CGFloat, startAngle:CGFloat, endAngle: CGFloat, clockwise: Bool)
    {
        self.init()
        self.move(to: CGPoint(x: centre.x, y:centre.y))
        self.addArc(withCenter: centre, radius:radius, startAngle:startAngle, endAngle: endAngle, clockwise:clockwise)
        self.close()
    }
}
