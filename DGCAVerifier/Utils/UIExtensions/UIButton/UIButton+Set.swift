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
//  UIButton+Set.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 26/07/21.
//

import UIKit

extension UIButton {
    
    var allStates: [UIControl.State] {
        return [.application, .disabled, .focused, .highlighted, .normal, .reserved, .selected]
    }
    
    func setImage(_ image: UIImage?) {
        allStates.forEach { self.setImage(image, for: $0) }
    }
    
    func setTitle(_ title: String?, uppercased: Bool = true) {
        UIView.performWithoutAnimation { [weak self] in
            let title = uppercased ? title?.localized.uppercased() : title?.localized
            self?.allStates.forEach { self?.setTitle(title, for: $0) }
            layoutIfNeeded()
        }
    }

}
