//
//  SwipeTableViewCellAction.swift
//
//  Created by Harsh Hungund on 25/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import Foundation
import UIKit

public class SwipeTableViewCellAction {
    public let image: UIImage
    public let handler: ((CountryCell) -> ())?
    
    init(image: UIImage, handler: ((CountryCell) -> ())? ) {
        self.image = image
        self.handler = handler
    }
}
