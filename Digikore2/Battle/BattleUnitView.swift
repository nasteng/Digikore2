//
//  BattleUnitView.swift
//  Digikore
//
//  Created by nasteng on 2017/08/06.
//
//


import UIKit

class BattleUnitView: UIView {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var sammonEffectImageView: UIImageView!
    @IBOutlet private weak var HPLabel: UILabel!
    @IBOutlet weak var unitImageView: UIImageView!
    @IBOutlet weak var HPBarView: UIView!
    @IBOutlet weak var elementImageView: UIImageView!
    @IBOutlet weak var HPBarWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var battleEffectImageView: UIImageView!
    private var gradientLayer: CAGradientLayer?
    private(set) var unit: Unit?
    private(set) var viewIdentifier: String?
    var isHighlighted: Bool = false
    
    // コードから初期化はここから
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    // 原則このinitを使う
    convenience init(unit: Unit, frame: CGRect) {
        self.init(frame: frame)
        self.unit = unit
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // xibからカスタムViewを読み込んで準備する
    private func commonInit() {
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BattleUnitView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
    }
    
    func setup(with unit: Unit) {
        if unit.unitType == .divine {
            self.sammonEffectImageView.image = UIImage.gif(name: "s22")
//            self.unitImageView.alpha = 0.0
            self.sammonEffectImageView.alpha = 0.0
//            self.HPBarView.alpha = 0.0
            baseView.alpha = 0.0
        }
        
        self.unitImageView.image = unit.batleImage
        self.elementImageView.image = unit.element.image
        self.viewIdentifier = unit.displayName
        self.HPLabel.text = "\(unit.status.hitPoint.present)/\(unit.status.hitPoint.max)"
        
        //グラデーションの開始色
        let topColor = UIColor(red:231 / 255, green: 76 / 255, blue: 60 / 255, alpha:1)
        //グラデーションの終了色
        let bottomColor = UIColor(red: 241 / 255, green: 196 / 255, blue: 15 / 255, alpha:1)
        
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        //グラデーションレイヤーを作成
        gradientLayer = CAGradientLayer()
        gradientLayer!.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer!.endPoint = CGPoint(x: 1.0, y: 0.0)
        updateHPBar(ratio: unit.status.hitPoint.present)

        //グラデーションの色をレイヤーに割り当てる
        gradientLayer!.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer!.frame = HPBarView.bounds

        //グラデーションレイヤーをビューの一番下に配置
        self.HPBarView.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    func updateHPLabel(with lastHP: Int) {
        guard let maxHP = unit?.status.hitPoint.max else {
            return
        }
        
        HPLabel.text = "\(lastHP)/\(maxHP)"
    }
    
    func updateHPBar(ratio: Int) {
        let lastHP = CGFloat(ratio)
        guard let maxHPInt = unit?.status.hitPoint.max else {
            return
        }
        let maxHP = CGFloat(maxHPInt)
        
        HPBarWidthConstraint.constant = frame.width * (lastHP / maxHP)
    }
    
    func flash(after: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .repeat, animations: {
            self.alpha = 0.0
            self.isHighlighted = true
        }, completion: nil)
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
            self.alpha = 1.0
            self.isHighlighted = false
            self.layer.removeAllAnimations()
            after?()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = HPBarView.bounds
    }
}
