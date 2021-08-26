//
//  GatewayConnection+Revocation.swift
//  Verifier
//
//  Created by Andrea Prosseda on 25/08/21.
//
import Foundation
import SwiftDGC

extension GatewayConnection {

    private var revocationUrl: String { "https://storage.googleapis.com/dgc-greenpass/200K.json" }
    
    func updateRevocationList(completion: ((String?) -> Void)? = nil) {
        getCRL { crl in

            guard let crl = crl else {
                completion?("server.error.generic.error".localized)
                return
            }
            
            CRLDataStorage.store(crl: crl)
            completion?(nil)
        }
    }

    private func getCRL(completion: ((CRL?) -> Void)?) {
        let restStartTime = Log.start(key: "[CRL] [REST]")
        session.request(revocationUrl).response {
            Log.end(key: "[CRL] [REST]", startTime: restStartTime)
            
            let jsonStartTime = Log.start(key: "[CRL] [JSON]")
            let decoder = JSONDecoder()
            let data = try? decoder.decode(CRL.self, from: $0.data ?? .init())
            Log.end(key: "[CRL] [JSON]", startTime: jsonStartTime)
            
            guard let crl = data else {
                completion?(nil)
                return
            }
            completion?(crl)
        }
    }
    
}
