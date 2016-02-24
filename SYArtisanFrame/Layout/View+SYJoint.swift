//
//  View+SYJoint.swift
//  SYArtisanFrame
//
//  Created by Sherlock Yao on 2/18/16.
//  Copyright © 2016 Sherlock Yao. All rights reserved.
//

import UIKit

public extension UIView {

    public func sy_top(top: Float) -> UIView {
        return self
    }
    
    public func sy_bottom(bottom: Float) -> UIView {
        return self
    }
    
    public func sy_left(left: Float) -> UIView {
        return self
    }
    
    public func sy_right(right: Float) -> UIView {
        return self
    }
    
    public func sy_width(width: Float) -> UIView {
        return self
    }
    
    public func sy_height(height: Float) -> UIView {
        return self
    }
    
    
    // store the current constraints
    internal var sy_jointConstraints: [SYJointConstraint] {
        get {
            if let constraints = objc_getAssociatedObject(self, &jointConstraintsKey) as? [SYJointConstraint] {
                return constraints
            }
            return []
        }
        set {
            objc_setAssociatedObject(self, &jointConstraintsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

private var jointConstraintsKey = ""
