//
//  UtilityExtensions.swift
//  AutoSampleApp
//
//  Created by Harsh Hungund on 05/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import UIKit

protocol StoryboardIdentifierMappable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifierMappable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    enum Storyboard: String {
        case main
        case launchScreen
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    func instantiateViewController<T: UIViewController>() -> T{
            guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
                fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
            }
            return viewController
    }
    
}



extension UIViewController: StoryboardIdentifierMappable { }

