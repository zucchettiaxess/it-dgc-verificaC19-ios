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
//  AppLabel.swift
//  Verifier
//
//  Created by Andrea Prosseda on 26/07/21.
//

import UIKit

class AppLabel: UILabel {
        
    @IBInspectable var bold: Bool = false       { didSet { initialize() } }
    @IBInspectable var size: CGFloat = 12       { didSet { initialize() } }
    @IBInspectable var uppercased: Bool = false { didSet { initialize() } }
    
    override var text: String? { didSet { toUppercase() } }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        font = Font.getFont(size: size, style: bold ? .bold : .regular)
        textColor = Palette.blueDark
        toUppercase()
    }

    func toUppercase() {
        guard uppercased else { return }
        guard (text?.uppercased() ?? "") != (text ?? "") else { return }
        text = text?.uppercased()
    }
}

