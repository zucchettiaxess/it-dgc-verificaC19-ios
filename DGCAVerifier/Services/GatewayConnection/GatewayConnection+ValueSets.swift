//
//  GatewayConnection+ValueSets.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 30/07/21.
//

import Foundation
import CertLogic
import SwiftDGC

extension GatewayConnection {
    
    private var valueSetsUrl: String { "https://dgca-businessrule-service.cfapps.eu10.hana.ondemand.com/valuesets" }
    //    private var valueSetsUrl: String { baseUrl + "/valuesets" }
    
    func loadValueSetsFromServer(completion: ((String?) -> Void)? = nil) {
        getListOfValueSets { valueSetsList in
            guard let valueSetsList = valueSetsList else {
                completion?("server.error.generic.error".localized)
                return
            }
            
            valueSetsList.forEach { valueSet in
                ValueSetsDataStorage.sharedInstance.add(valueSet: valueSet)
            }
            ValueSetsDataStorage.sharedInstance.lastFetch = Date()
            ValueSetsDataStorage.sharedInstance.save()
            completion?(nil)
        }
    }
    
    private func getListOfValueSets(completion: (([CertLogic.ValueSet]?) -> Void)?) {
        session.request(valueSetsUrl, method: .get).response {
            guard
                case let .success(result) = $0.result,
                let response = result,
                let responseStr = String(data: response, encoding: .utf8)
            else {
                completion?(nil)
                return
            }
            let valueSetsHashes: [ValueSetHash] = CertLogicEngine.getItems(from: responseStr)
            // Remove old hashes
            ValueSetsDataStorage.sharedInstance.valueSets = ValueSetsDataStorage.sharedInstance.valueSets.filter { valueSet in
                return !valueSetsHashes.contains(where: { valueSetHashe in
                    return valueSetHashe.hash == valueSet.hash
                })
            }
            // Downloading new hashes
            var valueSetsItems = [CertLogic.ValueSet]()
            let downloadingGroup = DispatchGroup()
            valueSetsHashes.forEach { valueSetHash in
                downloadingGroup.enter()
                if !ValueSetsDataStorage.sharedInstance.isValueSetExistWithHash(hash: valueSetHash.hash) {
                    self.getValueSets(valueSetHash: valueSetHash) { valueSet in
                        if let valueSet = valueSet {
                            valueSetsItems.append(valueSet)
                        }
                        downloadingGroup.leave()
                    }
                } else {
                    downloadingGroup.leave()
                }
            }
            downloadingGroup.notify(queue: .main) {
                completion?(valueSetsItems)
                print("Finished all requests.")
            }
        }
    }
    
    private func getValueSets(valueSetHash: CertLogic.ValueSetHash, completion: ((CertLogic.ValueSet?) -> Void)?) {
        let url = valueSetsUrl + "/" + valueSetHash.hash
        session.request(url, method: .get).response {
            guard
                case let .success(result) = $0.result,
                let response = result,
                let responseStr = String(data: response, encoding: .utf8)
            else {
                completion?(nil)
                return
            }
            if let valueSet: ValueSet = CertLogicEngine.getItem(from: responseStr) {
                let downloadedValueSetHash = SHA256.digest(input: response as NSData)
                if downloadedValueSetHash.hexString == valueSetHash.hash {
                    valueSet.setHash(hash: valueSetHash.hash)
                    completion?(valueSet)
                } else {
                    completion?(nil)
                }
                return
            }
            completion?(nil)
        }
    }
    
}
