//
//  MockGatewayConnection.swift.swift
//  VerifierTests
//
//

import Foundation
@testable import VerificaC19

class MockHomeViewModel: HomeViewModel {
    override func loadCertificates() {
        self.isScanEnabled.value = true
        self.isVersionOutdated.value = false
        self.isLoading.value = false
    }
}
