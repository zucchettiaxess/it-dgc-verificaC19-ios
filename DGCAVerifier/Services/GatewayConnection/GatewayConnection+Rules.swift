//
//  GatewayConnection+Rules.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 30/07/21.
//

import Foundation
import CertLogic
import SwiftDGC

extension GatewayConnection {
    
    private var rulesUrl: String { "https://dgca-businessrule-service.cfapps.eu10.hana.ondemand.com/rules" }
    //    private var rulesUrl: String { baseUrl + "/rules" }
    
    func loadRulesFromServer(completion: ((String?) -> Void)? = nil) {
        getListOfRules { rulesList in
            guard let rulesList = rulesList else {
                completion?("server.error.generic.error".localized)
                return
            }
            
            rulesList.forEach { rule in
                RulesDataStorage.sharedInstance.add(rule: rule)
            }
            RulesDataStorage.sharedInstance.lastFetch = Date()
            RulesDataStorage.sharedInstance.save()
            completion?(nil)
        }
    }
    
    private func getListOfRules(completion: (([CertLogic.Rule]?) -> Void)?) {
        session.request(rulesUrl, method: .get).response {
            guard
                case let .success(result) = $0.result,
                let response = result,
                let responseStr = String(data: response, encoding: .utf8)
            else {
                completion?(nil)
                return
            }
            let ruleHashes: [RuleHash] = CertLogicEngine.getItems(from: responseStr)
            // Remove old hashes
            RulesDataStorage.sharedInstance.rules = RulesDataStorage.sharedInstance.rules.filter { rule in
                return !ruleHashes.contains(where: { ruleHash in
                    return ruleHash.hash == rule.hash
                })
            }
            // Downloading new hashes
            var rulesItems = [CertLogic.Rule]()
            let downloadingGroup = DispatchGroup()
            ruleHashes.forEach { ruleHash in
                downloadingGroup.enter()
                if !RulesDataStorage.sharedInstance.isRuleExistWithHash(hash: ruleHash.hash) {
                    self.getRules(ruleHash: ruleHash) { rule in
                        if let rule = rule {
                            rulesItems.append(rule)
                        }
                        downloadingGroup.leave()
                    }
                } else {
                    downloadingGroup.leave()
                }
            }
            downloadingGroup.notify(queue: .main) {
                completion?(rulesItems)
                print("Finished all requests.")
            }
        }
    }
    
    private func getRules(ruleHash: CertLogic.RuleHash, completion: ((CertLogic.Rule?) -> Void)?) {
        let url = rulesUrl + "/" + ruleHash.country + "/" + ruleHash.hash
        session.request(url, method: .get).response {
            guard
                case let .success(result) = $0.result,
                let response = result,
                let responseStr = String(data: response, encoding: .utf8)
            else {
                completion?(nil)
                return
            }
            if let rule: Rule = CertLogicEngine.getItem(from: responseStr) {
                let downloadedRuleHash = SHA256.digest(input: response as NSData)
                if downloadedRuleHash.hexString == ruleHash.hash {
                    rule.setHash(hash: ruleHash.hash)
                    completion?(rule)
                } else {
                    completion?(nil)
                }
                return
            }
            completion?(nil)
        }
    }
    
}
