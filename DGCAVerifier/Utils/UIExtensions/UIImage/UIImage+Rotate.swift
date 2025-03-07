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
//  UIImage+Rotate.swift
//  Verifier
//
//  Created by Andrea Prosseda on 26/07/21.
//

import UIKit

public extension UIImage {
    
    func rotate(radians: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        context.translateBy(x: center.x, y: center.y)
        context.rotate(by: radians)
        context.translateBy(x: -center.x, y: -center.y)
        
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func rotate(degree: Int) -> UIImage? {
        let radians = CGFloat(Double(degree) * .pi / 180)
        return rotate(radians: radians)
    }
    
}
