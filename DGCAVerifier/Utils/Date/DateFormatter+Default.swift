/*
 *  license-start
 *  
 *  Copyright (C) 2021 Ministero della Salute and all other contributors
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
*/

//
//  DateFormatter+Default.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 26/06/21.
//

import Foundation

extension DateFormatter {
    
    static func getDefault(utc: Bool = true) -> DateFormatter {
        let df = DateFormatter()
        guard utc else { return df }
        df.timeZone = TimeZone(abbreviation: "UTC")
        return df
    }
}
