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
//  Font.swift
//  Verifier
//
//  Created by Andrea Prosseda on 29/07/21.
//

import Foundation
import UIKit

struct Font {
    
    static let FONT = "TitilliumWeb"
    
    enum Style {
        case bold
        case semiBold
        case regular
        case light
        
        var font: String {
            switch self {
            case .bold:     return FONT + "-Bold"
            case .semiBold: return FONT + "-SemiBold"
            case .regular:  return FONT + "-Regular"
            case .light:    return FONT + "-Light"
            }
        }
        
        var isBold: Bool {
            switch self {
            case .bold:     return true
            case .semiBold: return true
            default:        return false
            }
        }
    }
    
    static func getFont(size: CGFloat, style: Style = .regular) -> UIFont {
        let size = size * getScaleFactor(size)
        return getCustomFont(size, style) ?? getSystemFont(size, style)
    }
        
    private static func getCustomFont(_ size: CGFloat, _ style: Style) -> UIFont? {
        return UIFont(name: style.font, size: size)
    }
    
    private static func getSystemFont(_ size: CGFloat, _ style: Style) -> UIFont {
        return style.isBold ?
            UIFont.boldSystemFont(ofSize: size) :
            UIFont.systemFont(ofSize: size)
    }
    
    static var scaleFactor: CGFloat { getScaleFactor() }
    
    private static func getScaleFactor(_ size: CGFloat = 12) -> CGFloat {
        guard UIScreen.main.bounds.width < 375.0 else { return 1 }
        if (size > 20) { return 0.8 }
        return 0.85
    }
}
