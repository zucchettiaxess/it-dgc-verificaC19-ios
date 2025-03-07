//
/*-
 * ---license-start
 * eu-digital-green-certificates / dgca-verifier-app-ios
 * ---
 * Copyright (C) 2021 T-Systems International GmbH and all other contributors
 * ---
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---license-end
 */
//  
//  LocalData.swift
//  DGCAVerifier
//  
//  Created by Yannick Spreen on 4/25/21.
//  

import Foundation
import SwiftDGC
import SwiftyJSON

struct LocalData: Codable {
  static var sharedInstance = LocalData()

  var encodedPublicKeys = [String: [String]]()
  var resumeToken: String?
  var lastFetchRaw: Date?

var lastFetch: Date {
    get {
      lastFetchRaw ?? .init(timeIntervalSince1970: 0)
    }
    set(value) {
      lastFetchRaw = value
    }
  }

    mutating func add(kid: String, encodedPublicKey: String) {

    let list = encodedPublicKeys[kid] ?? []
    if list.contains(encodedPublicKey) {
      return
    }
    encodedPublicKeys[kid] = list + [encodedPublicKey]
  }
    
  static func set(resumeToken: String) {
    sharedInstance.resumeToken = resumeToken
  }

  public func save() {
    Self.storage.save(self)
  }

  static let storage = SecureStorage<LocalData>(fileName: "secure")

  static func initialize(completion: @escaping () -> Void) {
    storage.loadOverride(fallback: LocalData.sharedInstance) { success in
      guard let result = success else {
        return
      }
      let format = l10n("log.keys")
      print(String.localizedStringWithFormat(format, result.encodedPublicKeys.count))
      LocalData.sharedInstance = result
      completion()
    }
    HCert.publicKeyStorageDelegate = LocalDataDelegate.instance
  }
}

class LocalDataDelegate: PublicKeyStorageDelegate {
  func getEncodedPublicKeys(for kidStr: String) -> [String] {
    LocalData.sharedInstance.encodedPublicKeys[kidStr] ?? []
  }

  static var instance = LocalDataDelegate()
}
