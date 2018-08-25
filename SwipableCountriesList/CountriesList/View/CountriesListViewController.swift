//
//  CountriesListViewController.swift
//  SwipableCountriesList
//
//  Created by Harsh Hungund on 25/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import UIKit

class CountriesListViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var networkManager = NetworkManager()
    var  countriesViewModel = CountriesViewModel()
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.navigationItem.title = URLParameterConstants.COUNTRY_LIST_TITLE
        self.tableView.register(CountryCell.self)
        self.bindViewModel()
        self.tableView.dataSource = self.countriesViewModel
        self.tableView.delegate = self.countriesViewModel
        self.countriesViewModel.fetchCountriesList()
    }
    
    func bindViewModel()  {
        self.countriesViewModel.reloadCountriesListClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
