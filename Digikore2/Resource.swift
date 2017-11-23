//
//  Resource.swift
//  Digikore
//
//  Created by nasteng on 2017/07/09.
//
//

import Foundation
import UIKit

final class Resource: NSObject, NSCoding {
    
    let name: String                                // 資源名(ex: 光のオーブ)
    let imageName: String
    let image: UIImage                              // 資源image
    private(set) var quantity: Int                       // 資源保有量 デフォルト10000
    private(set) var incrementInterval: TimeInterval     // 増加間隔(秒)  デフォルト5秒
    private(set) var incrementAmount: Int                 // 増加量　デフォルトでは100
    private(set) var incrementTimer: Timer
    
    init(name: String,
         imageName: String,
         quantity: Int = 100000,
         incrementInterval: TimeInterval = 0.1,
         increaseAmount: Int = 100) {
        self.name = name
        self.imageName = imageName
        self.image = UIImage(named: imageName)!
        self.quantity = quantity
        self.incrementInterval = incrementInterval
        self.incrementAmount = increaseAmount
        self.incrementTimer = Timer()
        super.init()
    }
    
    private enum CodingKey: String {
        case name
        case imageName
        case quantity
        case incrementInterval
        case incrementAmount
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: CodingKey.name) as? String,
            let imageName = aDecoder.decodeObject(forKey: CodingKey.imageName) as? String,
            let image = UIImage(named: imageName)
            else {
                print("coder失敗")
                return nil
        }
        
        let quantity = aDecoder.decodeInteger(forKey: CodingKey.quantity),
        incrementInterval = aDecoder.decodeDouble(forKey: CodingKey.incrementInterval),
        increaseAmount = aDecoder.decodeInteger(forKey: CodingKey.incrementAmount)
        
        self.name = name
        self.imageName = imageName
        self.image = image
        self.quantity = quantity
        self.incrementInterval = incrementInterval
        self.incrementAmount = increaseAmount
        self.incrementTimer = Timer()
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKey.name)
        aCoder.encode(imageName, forKey: CodingKey.imageName)
        aCoder.encodeInteger(quantity, forKey: CodingKey.quantity)
        aCoder.encodeDouble(incrementInterval, forKey: CodingKey.incrementInterval)
        aCoder.encodeInteger(incrementAmount, forKey: CodingKey.incrementAmount)
    }
    
    func setUpTimer() {
        self.incrementTimer = Timer.scheduledTimer(timeInterval: incrementInterval, target: self, selector: #selector(increaseQuantity), userInfo: nil, repeats: true)
    }

    @objc func increaseQuantity() {
        self.quantity += incrementAmount
        let notification = Notification(name: Notification.Name(rawValue: self.name), object: self, userInfo: ["quantity": quantity])
        NotificationCenter.default.post(notification)
    }
    
    func manufacture(from interval: TimeInterval) {
        quantity += lround(interval / incrementInterval) * incrementAmount
    }
    
    func consume(_ amount: Int, completion: ((_ didConsume: Bool) -> Void)) {
        if quantity >= amount {
            self.quantity -= amount
            completion(true)
            return
        }
        
        completion(false)
    }
}
