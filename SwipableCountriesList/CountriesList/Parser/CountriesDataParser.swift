//
//  CountriesDataParser.swift
//  SwipableCountriesList
//
//  Created by Harsh Hungund on 26/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import Foundation
class CountriesDataParser {
    func parseCountriesData(json: [Any]) throws -> Array<CountryDetails> {
        var arrayOfCountries = [CountryDetails]()
        for  item  in json {
            let dictInfo = item as! [String:AnyObject]
            let name = dictInfo["name"]
            let currencies = dictInfo["currencies"] as? [AnyObject]
            let currencyName = currencies?.first!["name"]
            let languages = dictInfo["languages"] as? [AnyObject]
            let languageName = languages?.first!["name"]
            let  countryObject = CountryDetails(name: name as! String, currency: currencyName as! String, language: languageName as! String)
            arrayOfCountries.append(countryObject)
        }
        return arrayOfCountries
    }
}
