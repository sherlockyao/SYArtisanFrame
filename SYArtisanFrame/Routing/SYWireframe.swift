//
//  SYWireframe.swift
//  SYArtisanFrame
//
//  Created by Sherlock Yao on 12/21/15.
//  Copyright © 2015 Sherlock Yao. All rights reserved.
//

import UIKit

public typealias SYWireframeCompletionHandler = () -> Void
public typealias SYWireframeViewControllerBuilder = (params: Dictionary<String, AnyObject>) -> UIViewController
public typealias SYWireframeViewControllerNavigator = (fromViewController: UIViewController, toViewController: UIViewController, completionHandler: SYWireframeCompletionHandler) -> Void

/**
 Wireframe deal with all the view controller initialization, configuration, navigation, transition etc. works.
 
 The basic wireframe rules are configured in the .plist file. 
 A classic navigation flow from view controller <X> to <Y> will be like this:
 
    - wireframe look up configuration map for X with Port and Gate(optional), result Y
    - wireframe initialize Y with relevant builder and params
    - wireframe use relevant navigator to do the presentation from X to Y
*/
public class SYWireframe {
    public static let defaultWireframe = SYWireframe(plistFileName: defaultPropertyListFileName)
    
    private let codes: Dictionary<String, String>
    private let decodes: Dictionary<String, Dictionary<String, String>>
    private let destinations: Dictionary<String, Dictionary<String, String>>
    // view controller builders map: builderName -> builder
    private var builders: Dictionary<String, SYWireframeViewControllerBuilder>
    // view controller navigators map: navigatorName -> navigator
    private var navigators: Dictionary<String, SYWireframeViewControllerNavigator>
    
    public var transitionApparatus: SYWireframeTransitionApparatus?
    
    public init(plistFileName: String) {
        let path = NSBundle(forClass: self.dynamicType).pathForResource(plistFileName, ofType: "plist")
        let plist = NSDictionary(contentsOfFile: path!)!
        decodes = plist["Decodes"] as! Dictionary<String, Dictionary<String, String>>
        destinations = plist["Destinations"] as! Dictionary<String, Dictionary<String, String>>
        var codes = [String: String]()
        for (code, properties) in decodes {
            if let className = properties["class"] {
                codes.updateValue(className, forKey: code)
            }
        }
        self.codes = codes
        builders = [String: SYWireframeViewControllerBuilder]()
        navigators = [String: SYWireframeViewControllerNavigator]()
    }
    
    public class func setDefaultPlistFileName(name: String) {
        defaultPropertyListFileName = name
    }
    
    
    // MARK: Registration
    
    public func registerViewControllerBuilder(builder: SYWireframeViewControllerBuilder, forName builderName: String) {
        builders.updateValue(builder, forKey: builderName)
    }
    
    public func registerViewControllerNavigator(navigator: SYWireframeViewControllerNavigator, forName navigatorName: String) {
        navigators.updateValue(navigator, forKey: navigatorName)
    }
    
    // MARK: Configuration
    
    /**
    Override this method to setup your own configuration logic
    DO call super() while you override the method if you want reuse the transition setup flow
    
    - parameter toViewController:   the view controller to be configured, i.e. the destination controller
    - parameter fromViewController: the from view controller which present the configured controller
    - parameter withParams:         parameters
    */
    public func configureViewController(toViewController: UIViewController, fromViewController: UIViewController, withParams: Dictionary<String, AnyObject>) {
        if let transition = transitionApparatus {
            if toViewController is UINavigationController {
                transition.setupTransitionForNavigationController(toViewController as! UINavigationController)
            }
            transition.setupTransitionFromViewController(fromViewController, toViewController: toViewController)
        }
    }
    
    // MARK: Routing Methods
    
    public func navigateToPort(port: String, fromViewController: UIViewController) {
        self.navigateToPort(port, params: [String : AnyObject](), fromViewController: fromViewController)
    }
    
    public func navigateToPort(port: String, params: Dictionary<String, AnyObject>, fromViewController: UIViewController) {
        self.navigateToPort(port, params: params, fromViewController: fromViewController, completionHandler: { () -> Void in
            // do nothing
        })
    }
    
    public func navigateToPort(port: String, params: Dictionary<String, AnyObject>, fromViewController: UIViewController, completionHandler: SYWireframeCompletionHandler) {
        self.navigateToPort(port, gate: "", params: params, fromViewController: fromViewController, completionHandler: completionHandler)
    }
    
    public func navigateToPort(port: String, gate: String, params: Dictionary<String, AnyObject>, fromViewController: UIViewController, completionHandler: SYWireframeCompletionHandler) {
        let destinationKey = self.destinationKeyForPort(port, gate: gate, fromViewController: fromViewController)
        if let destination = destinations[destinationKey] {
            let toCode = destination["target"]
            let toViewController = buildViewControllerWithCode(toCode, params: params)
            configureViewController(toViewController, fromViewController: fromViewController, withParams: params)
            if let navigatorName = destination["navigator"] {
                let navigator = navigators[navigatorName]!
                navigator(fromViewController: fromViewController, toViewController: toViewController, completionHandler: completionHandler)
            }
        }
    }

    
    // MARK: Private Section
    
    private static var defaultPropertyListFileName = "SYWireframe"
    
    private func destinationKeyForPort(port: String, gate: String, fromViewController: UIViewController) -> String {
        let code = codes[_stdlib_getDemangledTypeName(fromViewController)]!
        if "" == gate {
            return code + "-" + port
        } else {
            return code + "-" + port + "-" + gate
        }
    }
    
    private func buildViewControllerWithCode(code: String?, params: Dictionary<String, AnyObject>) -> UIViewController {
        if nil == code {
            return UIViewController()
        }
        if let context = decodes[code!] {
            if let builderName = context["builder"] {
                let builder = builders[builderName]!
                return builder(params: params)
            } else {
                let storyboardName = context["storyboard"]!
                let identifier = context["id"]!
                return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(identifier)
            }
        } else {
            return UIViewController()
        }
    }
}
