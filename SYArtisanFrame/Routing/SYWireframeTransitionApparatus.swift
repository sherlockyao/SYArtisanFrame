//
//  SYWireframeTransitionApparatus.swift
//  SYArtisanFrame
//
//  Created by Sherlock Yao on 2/14/16.
//  Copyright © 2016 Sherlock Yao. All rights reserved.
//

import UIKit

public protocol SYWireframeTransitionApparatus {

    func setupTransitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController)
    
    func setupTransitionForNavigationController(navigationController: UINavigationController)
    
}