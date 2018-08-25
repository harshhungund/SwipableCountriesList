//
//  ViewController.swift
//  SwipableCountriesList
//
//  Created by Harsh Hungund on 25/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import UIKit

class ViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(
            name: UIStoryboard.Storyboard.main.filename,
            bundle: nil)
        if let countriesListViewController: CountriesListViewController = storyboard.instantiateViewController()
        {
            self.navigationController?.pushViewController(countriesListViewController, animated: true)
        }
    }
    
}


