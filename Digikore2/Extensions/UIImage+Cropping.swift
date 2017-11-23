//
//  UIImage+Cropping.swift
//  Degikore
//
//  Created by ### on 2017/06/21.
//
//

import Foundation
import UIKit

extension UIImage {
    func cropping(to: CGRect) -> UIImage? {
        let opaque = cgImage?.alphaInfo == .noneSkipFirst || cgImage?.alphaInfo == .noneSkipLast
        
        UIGraphicsBeginImageContextWithOptions(to.size, opaque, scale)
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
