//
//  CountriesViewModel.swift
//  SwipableCountriesList
//
//  Created by Harsh Hungund on 25/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import Foundation
import Foundation
import UIKit
class CountriesViewModel: NSObject{
    
    override init() {
        super.init()
    }
    let dataParser = CountriesDataParser()
    
    var countriesList: [CountryDetails] = [CountryDetails]() {
        didSet {
            self.reloadCountriesListClosure?()
        }
    }
    var networkManager = NetworkManager()
    var reloadCountriesListClosure: (()->())?
    
    func fetchCountriesList() {
        networkManager.getEndpointData(.countries){ data, response, error in
            if error != nil {
                print("Please check your network connection.")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.networkManager.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        print(NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        let parsedResponse = try self.dataParser.parseCountriesData(json: jsonData as! [Any] as! [Dictionary<String, AnyObject>])
                        self.countriesList = parsedResponse
                    }
                    catch {
                        print(NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    print(networkFailureError)
                }
            }
        }
    }
}

extension CountriesViewModel: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath, type: CountryCell.self)
        cell.tag = indexPath.row
        let countryObject = self.countriesList[indexPath.row]
        cell.configureCell(name: countryObject.name, currency: countryObject.currency, language: countryObject.language)
       // remove swiped cell using captured index
        cell.updateTableviewForDeletedRowClosure = {
            self.countriesList.remove(at: indexPath.row)
            UIView.animate(withDuration: 1.0, animations: {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            })
        }
        return cell
    }
}

extension CountriesViewModel: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
}
