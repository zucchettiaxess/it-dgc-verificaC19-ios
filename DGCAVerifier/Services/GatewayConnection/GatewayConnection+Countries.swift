//
//  GatewayConnection+Countries.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 30/07/21.
//

import Foundation
import SwiftDGC
import SwiftyJSON

extension GatewayConnection {
    // per provare cambiare session in AF su Gatewayconnection riga 62
    private var countriesUrl: String { "https://dgca-businessrule-service.cfapps.eu10.hana.ondemand.com/countrylist" }
    //    private var countriesUrl: String { baseUrl + "/countrylist" }
    
    func countryList(completion: ((String?) -> Void)? = nil) {
        getListOfCountry { countryList in
            guard let countryList = countryList else {
                completion?("server.error.generic.error".localized)
                return
            }
            CountryDataStorage.sharedInstance.countryCodes.removeAll()
            countryList.forEach { country in
                CountryDataStorage.sharedInstance.add(country: country)
            }
            CountryDataStorage.sharedInstance.lastFetch = Date()
            CountryDataStorage.sharedInstance.save()
            completion?(nil)
        }
    }
    
    private func getListOfCountry(completion: (([CountryModel]?) -> Void)?) {
        session.request(countriesUrl, method: .get).response {
            guard
                case let .success(result) = $0.result,
                let response = result,
                let responseStr = String(data: response, encoding: .utf8),
                let json = JSON(parseJSON: responseStr).array
            else {
                completion?(nil)
                return
            }
            let codes = json.compactMap { $0.string }
            var countryList: [CountryModel] = []
            codes.forEach { code in
                countryList.append(CountryModel(code: code))
            }
            completion?(countryList)
        }
    }
    
}

