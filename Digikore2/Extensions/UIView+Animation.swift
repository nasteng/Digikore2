//
//  UIView+Animation.swift
//  Digikore
//
//  Created by nasteng on 2017/10/08.
//

import Foundation
import UIKit

enum FadeType: TimeInterval {
    case
    Normal = 0.2,
    Slow = 1.0
}

extension UIView {
    func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeIn(duration: type.rawValue, completed: completed)
    }
    
    /** For typical purpose, use "public func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeIn(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration,
                                   animations: {
                                    self.alpha = 1
        }) { finished in
            completed?()
        }
    }
    
    func fadeIn(duration: TimeInterval = FadeType.Slow.rawValue, delay: TimeInterval, completed: (() -> ())? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            self.alpha = 1.0
        }) { _ in
            completed?()
        }
    }
    
    func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeOut(duration: type.rawValue, completed: completed)
    }
    
    /** For typical purpose, use "public func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeOut(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        UIView.animate(withDuration: duration
            , animations: {
                self.alpha = 0
        }) { [weak self] finished in
            self?.isHidden = true
            self?.alpha = 1
            completed?()
        }
    }
    
    func fadeOut(duration: TimeInterval = FadeType.Slow.rawValue, delay: TimeInterval, completed: (() -> ())? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            self.alpha = 0.0
        }) { [weak self] finished in
            self?.isHidden = true
            self?.alpha = 1.0
            completed?()
        }
    }
}
