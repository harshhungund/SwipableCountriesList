//
//  ReusableItem.swift
//  AutoSampleApp
//
//  Created by Harsh Hungund on 05/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import UIKit
protocol ReusableItem {
    
    static var reuseIdentifier: String { get }
    
}
extension ReusableItem {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableItem {}

extension UITableView {
    
    func dequeueCell<Cell: UITableViewCell>(for indexPath: IndexPath, type: Cell.Type) -> Cell where Cell: ReusableItem {
        return dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }
    
    func register<Cell: UITableViewCell>(_ type: Cell.Type) where Cell: ReusableItem {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
}

struct URLParameterConstants{
    static let BASE_URL = "https://restcountries.eu/rest/v2/all"//"https://api-aws-eu-qa-1.auto1-test.com​/"
    static let COUNTRY_LIST_TITLE = "Countries"
}
