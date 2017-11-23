//
//  EffectImageManager.swift
//  Digikore
//
//  Created by nasteng on 2017/08/12.
//
//

import Foundation
import UIKit

final class EffectImageManager {
    static var shared = EffectImageManager()

    enum Effect {
        case slash
        case fist
    }
    
    init() {}
    
    func effectImages(_ effect: Effect) -> [UIImage]? {
        switch effect {
        case .slash:
            var images: [UIImage]? = []
            for i in 0..<60 {
                if i < 10 {
                    guard let image = UIImage(named: "SwordSlash01_00000\(i).png") else {return nil}
                    images?.append(image)
                } else {
                    guard let image = UIImage(named: "SwordSlash01_0000\(i).png") else {return nil}
                    images?.append(image)
                }
            }
            return images
        case .fist:
            return nil
        }
    }
}
