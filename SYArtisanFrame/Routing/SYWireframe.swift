//
//  SYWireframe.swift
//  SYArtisanFrame
//
//  Created by Sherlock Yao on 12/21/15.
//  Copyright © 2015 Sherlock Yao. All rights reserved.
//

import Foundation

public typealias SYWireframeCompletionHandler = () -> Void
public typealias SYWireframeViewControllerBuilder = (params: Dictionary<String, AnyObject>) -> UIViewController

public class SYWireframe {
    static let defaultWireframe = SYWireframe(plistFileName: defaultPropertyListFileName)
    
    private let codes: Dictionary<String, String>
    private let decodes: Dictionary<String, Dictionary<String, String>>
    private let destinations: Dictionary<String, Dictionary<String, String>>
    // view controller builders map
    private var builders: Dictionary<String, SYWireframeViewControllerBuilder>
    
    init(plistFileName: String) {
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
    }
    
    public class func setDefaultPlistFileName(name: String) {
        defaultPropertyListFileName = name
    }
    
    // MARK: Registration
    
    public func registerViewControllerBuilder(builder: SYWireframeViewControllerBuilder, forName builderName: String) {
        builders.updateValue(builder, forKey: builderName)
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
//        let destinationKey = self.destinationKeyForPort(port, gate: gate, fromViewController: fromViewController)
//        if let destination = destinations[destinationKey] {
//            let toCode = destination["target"]
//            let toViewController = buildViewControllerWithCode(toCode, params: params)
//            //TODO:
//            
//        }
    }
    
    // MARK: Assembling Factory Methods
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
}
