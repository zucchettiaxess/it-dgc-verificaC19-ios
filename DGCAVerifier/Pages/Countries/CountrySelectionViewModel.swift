//
//  CountrySelectionViewModel.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 27/07/21.
//

import Foundation
import SwiftDGC

class CountrySelectionViewModel {
    
    let countries: [CountryModel]
    
    init() {
        countries = CountryDataStorage.sharedInstance.getSortedCountries
    }
    
    func getCountry(at index: Int) -> CountryModel? { countries.get(index) }

    func getIndexOfCountry(startingWith letter: String) -> Int? {
        countries.initials.firstIndex(where: { $0 == letter })
    }
}
