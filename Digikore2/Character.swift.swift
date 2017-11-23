//
//  Character.swift.swift
//  Degikore
//
//  Created by ### on 2017/06/23.
//
//

import Foundation
import UIKit
import UserNotifications

final class Character: Unit {
    enum Condition: String {
        case full
        case normal
        case hungry
        
        func description() -> String {
            switch self {
            case .full:
                return "満腹"
            case .normal:
                return "普通"
            case .hungry:
                return "空腹"
            }
        }
    }
    
    let standardImage: UIImage // 生成したら基本変更しない方針なのでletで宣言
    let downImage: UIImage
    
    private(set) var condition: Condition = .full {
        willSet(newValue) {
            if newValue == .hungry {
                // 通知送る処理
                let content = UNMutableNotificationContent()
                content.title = "!!注意!!"
                content.body = "腹が減ってるよ！！"
                content.sound = UNNotificationSound.default()
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
                
                let request = UNNotificationRequest(identifier: "gethungry", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
    
    // 後々APIを追加した時に、レスポンスがnilだったりすることを考慮してFailable Initializerにする
    init?(name: String, status: Status, element: Element, charaImage: UIImage?, multipile: Int? = nil) {
        guard let charaImage = charaImage, let images = charaImage.createImagesForGif(with: (width: 64, height: 64), range: 0..<3) , let gifURL = charaImage.createGifURL(from: images)?.absoluteString, let image = UIImage.gif(url: gifURL), let downImages = charaImage.createImagesForGif(with: (width: 64, height: 64), range: 6..<9, row: 5), let donwGifURL = charaImage.createGifURL(from: downImages)?.absoluteString, let downImage = UIImage.gif(url: donwGifURL) else {
            print("Error: Faild to Initialize Character")
            return nil
        }

        self.standardImage = image
        self.downImage = downImage
        super.init(name: name, status: status, unitType: UnitType.divine, element: element, multiple: multipile)
    }
    
    func getHungry() {
        switch condition {
        case .full:
            self.condition = .normal
        case .normal, .hungry:
            self.condition = .hungry
        }
    }
    
    func getFull() {
        self.condition = .full
    }
}
