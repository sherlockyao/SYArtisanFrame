//
//  SYJointConstraint.swift
//  SYArtisanFrame
//
//  Created by Sherlock Yao on 2/18/16.
//  Copyright © 2016 Sherlock Yao. All rights reserved.
//

import UIKit

enum SYJointPosition {
    case Top, Bottom, Left, Right
    case CenterX, CenterY
    case Width, Height
}

class SYJointConstraint {

    let constraint: NSLayoutConstraint
    let position: SYJointPosition
    
    init(_ constraint: NSLayoutConstraint, _ position: SYJointPosition) {
        self.constraint = constraint
        self.position = position
    }

}

//private func closestCommonSuperviewFromView(fromView: UIView?, toView: UIView?) -> UIView? {
//    var views = Set<UIView>()
//    var fromView = fromView
//    var toView = toView
//    repeat {
//        if let view = toView {
//            if views.contains(view) {
//                return view
//            }
//            views.insert(view)
//            toView = view.superview
//        }
//        if let view = fromView {
//            if views.contains(view) {
//                return view
//            }
//            views.insert(view)
//            fromView = view.superview
//        }
//    } while (fromView != nil || toView != nil)
//    
//    return nil
//}
