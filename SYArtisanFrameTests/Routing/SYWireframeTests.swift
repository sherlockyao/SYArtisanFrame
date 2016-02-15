//
//  SYWireframeTests.swift
//  SYArtisanFrame
//
//  Created by Sherlock Yao on 2/14/16.
//  Copyright © 2016 Sherlock Yao. All rights reserved.
//

import XCTest
@testable import SYArtisanFrame

class SYHomeViewController: UIViewController {
    var executedFlag = false
    
    override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        executedFlag = true
    }
}

class SYWireframeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        SYWireframe.setDefaultPlistFileName("SYWireframe-Sample")
        SYWireframe.defaultWireframe.registerViewControllerBuilder({ (params) -> UIViewController in
            return UIViewController()
            }, forName: "list")
        SYWireframe.defaultWireframe.registerDefaultNavigators()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        let wireframe = SYWireframe.defaultWireframe
        XCTAssertNotNil(wireframe)
    }
    
    func testNavigateToPort() {
        let viewController = SYHomeViewController()
        SYWireframe.defaultWireframe.navigateToPort("List", gate: "Products", params: [String: AnyObject](), fromViewController: viewController) { () -> Void in
            //do nothing
        }
        XCTAssertTrue(viewController.executedFlag)
    }
}
