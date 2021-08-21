//
//  RevokedDCC.swift
//  Verifier
//
//  Created by Davide Aliti on 20/08/21.
//

import Foundation
import RealmSwift

class RevokedDCC: Object {
    @Persisted var hashedUVCI: String = ""
}
