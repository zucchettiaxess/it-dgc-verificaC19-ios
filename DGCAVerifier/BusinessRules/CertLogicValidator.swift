//
//  CertLogicValidator.swift
//  Verifier
//
//  Created by Andrea Prosseda on 28/07/21.
//

import Foundation
import SwiftDGC
import CertLogic

struct CertLogicValidator: Validator {
    
    static let defaultCode = "IT"
    static var manager: CertLogicEngineManager { CertLogicEngineManager.sharedInstance }
    
    static func getStatus(from hCert: HCert) -> Status {
        let results = validate(hCert)
        if (isNotValidYet(results)) { return .notValidYet }
        if (!results.isEmpty)       { return .notValid }
        return .valid
    }
    
    private static func isNotValidYet(_ results: [ValidationResult]) -> Bool {
        return false
    }
    
    private static func validate(_ hCert: HCert) -> [ValidationResult] {
        let bodyString = hCert.body.rawString() ?? ""
        let results = manager.validate(
            filter: getFilterParameter(from: hCert),
            external: getExternalParameter(from: hCert),
            payload: bodyString
        )
        let invalidResults = results.filter { $0.result != .passed }
        log(invalidResults, for: hCert)
        return invalidResults
    }
    
    private static func getFilterParameter(from hCert: HCert) -> FilterParameter {
        return .init(
            validationClock: Date(),
            countryCode: hCert.ruleCountryCode ?? defaultCode,
            certificationType: hCert.certificateType
        )
    }
    
    private static  func getExternalParameter(from hCert: HCert) -> ExternalParameter {
        let storage = ValueSetsDataStorage.sharedInstance
        let valueSets = storage.getValueSetsForExternalParameters()
        return .init(
            validationClock: Date(),
            valueSets: valueSets,
            exp: hCert.exp,
            iat: hCert.iat,
            issuerCountryCode: hCert.issCode,
            kid: hCert.kidStr
        )
    }
    
}

extension CertLogicValidator {
    
    static func log(_ results: [ValidationResult], for hCert: HCert) {
        guard !results.isEmpty else { return }
        print("\n>>> VALIDATION RESULT <<<")
        results
            .sorted(by: { $0.result.rawValue < $1.result.rawValue })
            .forEach {
                let error = getError(from: $0)
                let details = getDetails(from: $0, for: hCert)
                let type = $0.result.name
                print("[\(type)] error: \(error), details: \(details)")
            }
    }
    
    static func getError(from result: ValidationResult) -> String {
        let error = result.validationErrors?.first?.localizedDescription
        return error ?? result.rule?.getLocalizedErrorString(locale: "EN") ?? "?"
    }
    
    static func getDetails(from result: ValidationResult, for hCert: HCert) -> String {
        guard let rule = result.rule else { return "?" }
        let filter = getFilterParameter(from: hCert)
        return manager.getRuleDetailsError(rule: rule, filter: filter).toString
    }
    
}


fileprivate extension Dictionary where Key == String, Value == String {
    
    var toString: String {
        var detailsError = ""
        keys.forEach({ detailsError += $0 + ": " + (self[$0] ?? "") + " " })
        return detailsError
    }
    
}

