//
//  CameraViewControllerTests.swift
//  VerifierTests
//
//

import XCTest
import UIKit
import SwiftyJSON
@testable import SwiftDGC
@testable import VerificaC19

class VerificationViewModelTests: XCTestCase {

    var hcert: HCert!
        
    var validViewModel: VerificationViewModel!
    var invalidViewModel: VerificationViewModel!
    var expiredViewModel: VerificationViewModel!
    var nonValidViewModel: VerificationViewModel!
    
    var payload: String!
    var bodyString: String!
    var encodedPublicKey: String!
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        payload = "HC1:6BFOXN%TS3DHPVO13J /G-/2YRVA.Q/R82JD2FCJG96V75DOW%IY17EIHY P8L6IWM$S4U45P84HW6U/4:84LC6 YM::QQHIZC4.OI1RM8ZA.A5:S9MKN4NN3F85QNCY0O%0VZ001HOC9JU0D0HT0HB2PL/IB*09B9LW4T*8+DCMH0LDK2%KI*V AQ2%KYZPQV6YP8722XOE7:8IPC2L4U/6H1D31BLOETI0K/4VMA/.6LOE:/8IL882B+SGK*R3T3+7A.N88J4R$F/MAITHW$P7S3-G9++9-G9+E93ZM$96TV6QRR 1JI7JSTNCA7G6MXYQYYQQKRM64YVQB95326FW4AJOMKMV35U:7-Z7QT499RLHPQ15O+4/Z6E 6U963X7$8Q$HMCP63HU$*GT*Q3-Q4+O7F6E%CN4D74DWZJ$7K+ CZEDB2M$9C1QD7+2K3475J%6VAYCSP0VSUY8WU9SG43A-RALVMO8+-VD2PRPTB7S015SSFW/BE1S1EV*2Q396Q*4TVNAZHJ7N471FPL-CA+2KG-6YPPB7C%40F18N4"
        encodedPublicKey = "MIIEDzCCAfegAwIBAgIURldu5rsfrDeZtDBxrJ+SujMr2IswDQYJKoZIhvcNAQELBQAwSTELMAkGA1UEBhMCSVQxHzAdBgNVBAoMFk1pbmlzdGVybyBkZWxsYSBTYWx1dGUxGTAXBgNVBAMMEEl0YWx5IERHQyBDU0NBIDEwHhcNMjEwNTEyMDgxODE3WhcNMjMwNTEyMDgxMTU5WjBIMQswCQYDVQQGEwJJVDEfMB0GA1UECgwWTWluaXN0ZXJvIGRlbGxhIFNhbHV0ZTEYMBYGA1UEAwwPSXRhbHkgREdDIERTQyAxMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEnL9+WnIp9fvbcocZSGUFlSw9ffW/jbMONzcvm1X4c+pXOPEs7C4/83+PxS8Swea2hgm/tKt4PI0z8wgnIehoj6OBujCBtzAfBgNVHSMEGDAWgBS+VOVpXmeSQImXYEEAB/pLRVCw/zBlBgNVHR8EXjBcMFqgWKBWhlRsZGFwOi8vY2Fkcy5kZ2MuZ292Lml0L0NOPUl0YWx5JTIwREdDJTIwQ1NDQSUyMHhcMSxPPU1pbmlzdGVybyUyMGRlbGxhJTIwU2FsdXRlLEM9SVQwHQYDVR0OBBYEFC4bAbCvpArrgZ0E+RrqS8V7TNNIMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAgEAjxTeF7yhKz/3PKZ9+WfgZPaIzZvnO/nmuUartgVd3xuTPNtd5tuYRNS/1B78HNNk7fXiq5hH2q8xHF9yxYxExov2qFrfUMD5HOZzYKHZcjcWFNHvH6jx7qDCtb5PrOgSK5QUQzycR7MgWIFinoWwsWIrA1AJOwfUoi7v1aoWNMK1eHZmR3Y9LQ84qeE2yDk3jqEGjlJVCbgBp7O8emzy2KhWv3JyRZgTmFz7p6eRXDzUYHtJaufveIhkNM/U8p3S7egQegliIFMmufvEyZemD2BMvb97H9PQpuzeMwB8zcFbuZmNl42AFMQ2PhQe27pU0wFsDEqLe0ETb5eR3T9L6zdSrWldw6UuXoYV0/5fvjA55qCjAaLJ0qi16Ca/jt6iKuws/KKh9yr+FqZMnZUH2D2j2i8LBA67Ie0JoZPSojr8cwSTxQBdJFI722uczCj/Rt69Y4sLdV3hNQ2A9hHrXesyQslr0ez3UHHzDRFMVlOXWCayj3LIgvtfTjKrT1J+/3Vu9fvs1+CCJELuC9gtVLxMsdRc/A6/bvW4mAsyY78ROX27Bi8CxPN5IZbtiyjpmdfr2bufDcwhwzdwsdQQDoSiIF1LZqCn7sHBmUhzoPcBJdXFET58EKow0BWcerZzpvsVHcMTE2uuAUr/JUh1SBpoJCiMIRSl+XPoEA2qqYU="
        LocalData.sharedInstance.encodedPublicKeys = [:]
        LocalData.sharedInstance.encodedPublicKeys["NJpCsMLQco4="] = [encodedPublicKey]
        print(LocalDataDelegate.instance)
        HCert.publicKeyStorageDelegate = LocalDataDelegate.instance
        hcert = HCert(from: payload)

        bodyString = "{\"4\": 1628553600, \"6\": 1620926082, \"1\": \"Ministero della Salute\", \"-260\": {\"1\": {\"ver\": \"1.0.0\", \"dob\": \"1977-06-16\", \"v\": [{\"ma\": \"ORG-100030215\", \"sd\": 2, \"dt\": \"2021-06-08\", \"co\": \"IT\", \"ci\": \"01IT67DA8332EF2C4E6780ABA5DF078A018E#0\", \"mp\": \"EU/1/20/1528\", \"is\": \"Ministero della Salute\", \"tg\": \"840539006\", \"vp\": \"1119349007\", \"dn\": 2}], \"nam\": {\"gnt\": \"MARILU<TERESA\", \"gn\": \"Marilù Teresa\", \"fn\": \"Di Caprio\", \"fnt\": \"DI<CAPRIO\"}}}}"
        
        LocalData.sharedInstance.settings = []
    }
    
    override func tearDownWithError() throws {
        payload = nil
        hcert = nil
        bodyString = nil
        encodedPublicKey = nil
        LocalData.sharedInstance.settings = []
        LocalData.sharedInstance.encodedPublicKeys = [:]
        HCert.publicKeyStorageDelegate = nil
    }

    func testInvalidQR() {
        invalidViewModel = VerificationViewModel(hCert: nil)
        
        XCTAssertEqual(invalidViewModel.status, .invalidQR)
        XCTAssertEqual(invalidViewModel.imageName, "icon_misuse")
        XCTAssertEqual(invalidViewModel.title, "result.invalid.title".localized)
        XCTAssertEqual(invalidViewModel.description, "result.invalidQR.description".localized)
        XCTAssertNil(invalidViewModel.birthDateString)
        XCTAssertNil(invalidViewModel.resultItems)
    }
    
    func testValidModel() {

        let vaccineSettingStartDay = Setting(name: "vaccine_start_day_complete", type: "EU/1/20/1528", value: "-10000")
        let vaccineSettingEndDay = Setting(name: "vaccine_end_day_complete", type: "EU/1/20/1528", value: "10000")
        LocalData.sharedInstance.addOrUpdateSettings(vaccineSettingStartDay)
        LocalData.sharedInstance.addOrUpdateSettings(vaccineSettingEndDay)

        validViewModel = VerificationViewModel(hCert: hcert)

        XCTAssertEqual(validViewModel.status, .valid)
        XCTAssertEqual(validViewModel.imageName, "icon_checkmark-filled")
        XCTAssertEqual(validViewModel.title, "result.valid.title".localized)
        XCTAssertEqual(validViewModel.description, "result.valid.description".localized)
        XCTAssertEqual(validViewModel.birthDateString, "16/06/1977")
        XCTAssertEqual(validViewModel.resultItems?.count, 2)

        XCTAssertNotNil(validViewModel.hCert)

        XCTAssertEqual(validViewModel.hCert?.standardizedLastName, "DI​<​CAPRIO")
        XCTAssertEqual(validViewModel.hCert?.standardizedFirstName, "MARILU​<​TERESA")

        XCTAssertEqual(validViewModel.hCert?.fullName, "Marilù Teresa Di Caprio")
        XCTAssertEqual(validViewModel.hCert?.firstName, "Marilù Teresa")
        XCTAssertEqual(validViewModel.hCert?.lastName, "Di Caprio")
    }

    func testExpiredModel() {
        let vaccineSettingStartDay = Setting(name: "vaccine_start_day_complete", type: "EU/1/20/1528", value: "0")
        let vaccineSettingEndDay = Setting(name: "vaccine_end_day_complete", type: "EU/1/20/1528", value: "1")
        LocalData.sharedInstance.addOrUpdateSettings(vaccineSettingStartDay)
        LocalData.sharedInstance.addOrUpdateSettings(vaccineSettingEndDay)
        let todayDate : Date = Date()
        let futureDate = Calendar.current.date(byAdding: .day, value: 2, to: todayDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let futureDateFormatted = dateFormatter.string(from: futureDate)
        bodyString = bodyString.replacingOccurrences(of: "\"dt\": \"2021-06-08\"", with: "\"dt\": \"\(futureDateFormatted)\"")
        hcert.body = JSON(parseJSON: bodyString)[ClaimKey.hCert.rawValue][ClaimKey.euDgcV1.rawValue]

        expiredViewModel = VerificationViewModel(hCert: hcert)

        XCTAssertEqual(expiredViewModel?.description, "result.expired.description".localized)
        XCTAssertEqual(expiredViewModel?.status, .expired)
    }

    func testNonValidModel() {
        hcert.body = JSON(parseJSON: bodyString)[ClaimKey.hCert.rawValue][ClaimKey.euDgcV1.rawValue]
        nonValidViewModel = VerificationViewModel(hCert: hcert)

        XCTAssertEqual(nonValidViewModel.description, "result.notValid.description".localized)
        XCTAssertEqual(nonValidViewModel?.status, .notValid)
    }
    
}
