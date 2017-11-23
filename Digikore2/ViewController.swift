//
//  ViewController.swift
//  Digikore
//
//  Created by nasteng on 2017/06/20.
//
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet private weak var name: UILabel!
    
    @IBOutlet private weak var strLabel: UILabel!
    
    @IBOutlet private weak var defLabel: UILabel!
    
    @IBOutlet private weak var lucLabel: UILabel!
    
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var resourceImageView: UIImageView!
    @IBOutlet private weak var resourceQuantityLabel: UILabel!
    
    private var timer = Timer()
    private var conditionTimer = Timer()
    private var resource: Resource = Resource(name: "光のオーブ", imageName: "r_shine.png")
    
    private var valkyrie: Character!
    
    private var isLeft: Bool = true {
        willSet(newValue) {
            // 新しい値がtrueだったら正しい方向に、falseだったら反転させる
            if newValue {
                imageView.transform = CGAffineTransform(scaleX: 1 , y: 1)
            } else {
                imageView.transform = CGAffineTransform(scaleX: -1 , y: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // キャラクターのインスタンスを生成してViewControllerのプロパティに設定
        guard let valkyrie = Character(name: "【戦乙女】ヴァルキリー", status: Status(hp: 1000 , str: 400, def: 300, agi: 100), element: .ray, charaImage: UIImage(named: "sozai.png")) else {
            return
        }

        self.valkyrie = valkyrie
        
        // imageViewのimageにキャラのimageを設定
        imageView.image = valkyrie.standardImage
        name.text = valkyrie.displayName
        name.adjustsFontSizeToFitWidth = true
        
//        strLabel.text = "攻撃力: \(String(describing: valkyrie.status.str))"
//        defLabel.text = "防御力: \(String(describing: valkyrie.status.def))"
//        lucLabel.text = "天運: \(String(describing: valkyrie.status.luc))"
//        conditionLabel.text =  "状態: " + valkyrie.condition.description()
        
        if let savedObject = UserDefaults.standard.object(forKey: "resource") as? [String: Any] {
            
            guard let parsedDate = parse(from: savedObject) else { return }
            resource = parsedDate.resource
            resource.manufacture(from: parsedDate.interval)
        }
        
        resource.setUpTimer()
        resourceImageView.image = resource.image
        resourceQuantityLabel.text = String(resource.quantity)
        resourceQuantityLabel.sizeToFit()
        
        NotificationCenter.default.addObserver(forName: Notification.Name(resource.name), object: nil, queue: .main) {notification in
            self.reloadResource(with: notification)
        }
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillTerminate, object: nil, queue: .main) { (_) in
            print("willTernimate...")
            
            // 資源をシリアライズ化、アプリ終了時刻とともにUserDefaultsに保存する
            let serializeResource = NSKeyedArchiver.archivedData(withRootObject: self.resource),
                terminateDate = Date(),
            saveData: [String: Any] = ["resource": serializeResource,
            "terminateDate": terminateDate]
            
            let userDefault = UserDefaults.standard
            userDefault.set(saveData, forKey: "resource")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.shared.play(.bgm(.hometown))
        // 5秒で腹が減る
        conditionTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(reloadCondition), userInfo: nil, repeats: true)
    }
    
    // UserDefaultsに保存されたオブジェクトをパースして(Resouce, TimeInterval)のタプルで返すメソッド
    func parse(from savedObject: [String: Any]) -> (resource: Resource, interval: TimeInterval)? {
        
        guard let parsedResourceData = savedObject["resource"] as? Data,
                let resource = NSKeyedUnarchiver.unarchiveObject(with: parsedResourceData) as? Resource,
            let parsedTerminateDate = savedObject["terminateDate"] as? Date else {
                return nil
        }
        
        return (resource, Date().timeIntervalSince(parsedTerminateDate))
    }
    
    func reloadResource(with notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Int],
            let quantity = userInfo["quantity"] else {
                return
        }
        
        resourceQuantityLabel.text = String(quantity)
        resourceQuantityLabel.sizeToFit()
    }
    
    @objc func reloadCondition() {
        valkyrie.getHungry()
        switch valkyrie.condition {
        case .hungry:
            imageView.image = valkyrie.downImage
            conditionTimer.invalidate()
        default: break
        }
        conditionLabel.text =  "状態: " + valkyrie.condition.description()
    }

    @objc func move(_ timer: Timer) {
        if valkyrie.condition != .hungry {
            // キャラ画像のframeを変数に格納
            var frame = imageView.frame
            
            // 移動量を定義して変数に格納
            let moveX: CGFloat = 50.0
            
            // 画面の左端(x座標が0)に到達したら
            if frame.origin.x < 0 {
                // 右を向いてることを表すためにフラグをfalseにする
                isLeft = false
                
                // もしキャラのx座標が右端(画面の最大x座標 - imageViewのサイズ分)に到達したら
            } else if frame.origin.x > view.frame.maxX - imageView.frame.width {
                // 左を向いていることを表すためにフラグをtrueにする
                isLeft = true
            }
            
            // 左を向いていれば左に動かすためにx軸の値をマイナス、逆ならプラスする
            isLeft ? (frame.origin.x -= moveX) : (frame.origin.x += moveX)
            
            // imageViewのframeに代入
            imageView.frame = frame
        }
    }

    @IBAction func startTimer(_ sender: UIButton) {
        // タイマーが動いていれば
        if timer.isValid {
            // タイマーを止める
            timer.invalidate()
            sender.setTitle("start", for: .normal)
        } else {
            sender.setTitle("stop", for: .normal)
            // そうでなければ動かす
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(move(_:)), userInfo: nil, repeats: true)
            timer.fire()
        }
        
        SoundManager.shared.play(.select)
    }
    
    @IBAction func feed(_ sender: Any) {
        let amount = 100
        resource.consume(amount) { didConsume in
            if didConsume {
                let targetFrame = self.resourceQuantityLabel.frame
                
                // 資源量表示ラベルのすぐとなりに消費ラベルのrectを設定する
                let rect = CGRect(x: targetFrame.maxX + 10, y: targetFrame.origin.y, width: 300, height: 20)
                let label = UILabel(frame: rect)
                label.text = "-\(amount)"
                
                self.view.addSubview(label)
                
                // 1秒間かけてy軸が0になるように ＋ 徐々に透明になるようにアニメーションさせる
                UIView.animate(withDuration: 1.0, animations: { 
                    label.alpha = 0
                    label.frame = CGRect(origin: CGPoint(x: label.frame.origin.x, y: 0), size: label.frame.size)
                }, completion: { (didFinish) in
                    if didFinish {
                        // アニメーションが終了したらremoveする
                        label.removeFromSuperview()
                    }
                })
                
                self.resourceQuantityLabel.text = String(self.resource.quantity)
                self.resourceQuantityLabel.sizeToFit()
                
                self.valkyrie.getFull()
                self.imageView.image = self.valkyrie.standardImage
                self.conditionLabel.text =  "状態: " + self.valkyrie.condition.description()
                
                // 満腹状態に戻るのでタイマーがどんな状態でも初期化する
                self.conditionTimer.invalidate()
                self.conditionTimer = Timer.scheduledTimer(timeInterval: 4.0 , target: self, selector: #selector(self.reloadCondition), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
