//
//  UINavigationController+Orientation.swift
//  Digikore
//
//  Created by nasteng on 2017/09/28.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let _ = self.visibleViewController {
            return self.visibleViewController!.supportedInterfaceOrientations
        }
        
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.landscapeRight]
        return orientation
    }
    
    open override var shouldAutorotate: Bool {
        if let _ = self.visibleViewController {
            return self.visibleViewController!.shouldAutorotate
        }
        
        return false
    }
}
