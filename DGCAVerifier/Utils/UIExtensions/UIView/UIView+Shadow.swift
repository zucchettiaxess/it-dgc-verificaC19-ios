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
//  UIView+Shadow.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 26/07/21.
//

import UIKit

public extension UIView {
        
    func addShadow(color: UIColor = .black.withAlphaComponent(0.8),
                   alpha: Float = 0.4,
                   x: CGFloat = 0,
                   y: CGFloat = 3,
                   blur: CGFloat = 8,
                   spread: CGFloat = 0) {
        self.layer.addShadow(color: color, alpha: alpha, x: x, y: y, blur: blur, spread: spread)
    }
    
    func removeShadow() {
        addShadow(color: .white, alpha: 0.0 , x: 0, y: 0, blur: 0, spread: 0)
    }

//    func addShadow(_ shadowColor: CGColor? = UIColor.black.withAlphaComponent(0.2).cgColor, shadowOffset: CGSize? = CGSize(width: 0.0, height: 2.0), shadowOpacity: Float? = 0.5, shadowRadius: CGFloat? = 2.0) {
//        if let shadowColor = shadowColor {
//            self.layer.shadowColor = shadowColor
//        }
//        if let shadowOffset = shadowOffset {
//            self.layer.shadowOffset = shadowOffset
//        }
//        if let shadowOpacity = shadowOpacity {
//            self.layer.shadowOpacity = shadowOpacity
//        }
//        if let shadowRadius = shadowRadius {
//            self.layer.shadowRadius = shadowRadius
//        }
//    }
    
    func hideShadow() {
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.0
        self.layer.shadowRadius = 0.0
    }
}
