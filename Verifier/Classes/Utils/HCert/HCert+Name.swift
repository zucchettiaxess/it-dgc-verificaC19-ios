//
//  HCert+Name.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 27/06/21.
//

import Foundation
import SwiftDGC

extension HCert {
    private var listItems: [InfoSection]? {
        self.info.filter { !$0.isPrivate }
    }
    var standardizedFirstName: String? {
        return listItems?.filter { $0.header == l10n("header.std-gn")}.first?.content
    }
    var standardizedLastName: String? {
        return listItems?.filter { $0.header == l10n("header.std-fn")}.first?.content
    }
    
    var firstName: String {
        return self.body["nam"]["gn"].string ?? ""
    }
    
    var lastName: String {
        return self.body["nam"]["fn"].string ?? ""
    }
}
