//
//  CountryModel+Name.swift
//  Verifier
//
//  Created by Andrea Prosseda on 30/07/21.
//

import SwiftDGC

extension CountryModel {
    
    var localizedName: String {
        return name
        return ("country." + code).localized
    }
}
