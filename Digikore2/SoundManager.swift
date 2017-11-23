//
//  SoundManager.swift
//  Degikore
//
//  Created by ### on 2017/07/01.
//
//

import Foundation
import AVFoundation

enum Result: String {
    case win
    case lose
}


final class SoundManager {
    
    enum Situation: String {
        case hometown
        case battle
    }
    
    enum Unit: String {
        case divine
        case enemy
    }
    

    
    enum SoundType {
        case bgm(Situation)
        case effect(Unit)
        case select
        case result(Result)
        
        var path: URL {
            switch self {
            case .bgm(let situation):
                switch situation {
                case .hometown:
                    return Bundle.main.url(forResource: "hometown", withExtension: "m4a")!
                case .battle:
                    return Bundle.main.url(forResource: "battle", withExtension: "m4a")!
                }
            case .effect(let unit):
                switch unit {
                case .divine:
                    return Bundle.main.url(forResource: "sword-slash1", withExtension: "mp3")!
                case .enemy:
                    return Bundle.main.url(forResource: "punch-middle2", withExtension: "mp3")!
                }
            case .select:
                return Bundle.main.url(forResource: "select", withExtension: "mp3")!
            case .result(let result):
                switch result {
                case .win:
                    return Bundle.main.url(forResource: "win", withExtension: "m4a")!
                case .lose:
                    return Bundle.main.url(forResource: "lose", withExtension: "m4a")!
                }
            }
        }
    }
    
    static var shared = SoundManager()
    
    private init() {
        do {
            try self.bgmPlayer = AVAudioPlayer(contentsOf: SoundType.bgm(.hometown).path)
            try self.battlePlayer = AVAudioPlayer(contentsOf: SoundType.bgm(.battle).path)
            try self.divineEffectPlayer = AVAudioPlayer(contentsOf: SoundType.effect(.divine).path)
            try self.enemyEffectPlayer = AVAudioPlayer(contentsOf: SoundType.effect(.enemy).path)
            try self.selectPlayer = AVAudioPlayer(contentsOf: SoundType.select.path)
            try self.winPlayer = AVAudioPlayer(contentsOf: SoundType.result(.win).path)
            try self.losePlayer = AVAudioPlayer(contentsOf: SoundType.result(.lose).path)
        } catch {
            print("Failed To Initialize SoundPlayer")
            self.bgmPlayer = AVAudioPlayer()
            self.selectPlayer = AVAudioPlayer()
            self.battlePlayer = AVAudioPlayer()
            self.divineEffectPlayer = AVAudioPlayer()
            self.enemyEffectPlayer = AVAudioPlayer()
            self.winPlayer = AVAudioPlayer()
            self.losePlayer = AVAudioPlayer()
        }
        self.setupPlayer()
    }
    
    private var bgmPlayer: AVAudioPlayer!
    private var battlePlayer: AVAudioPlayer!
    private var selectPlayer: AVAudioPlayer!
    private var divineEffectPlayer: AVAudioPlayer!
    private var enemyEffectPlayer: AVAudioPlayer!
    private var winPlayer: AVAudioPlayer!
    private var losePlayer: AVAudioPlayer!
    private var players: [AVAudioPlayer] = []
    
    private func setupPlayer() {
        bgmPlayer.numberOfLoops = -1
        battlePlayer.numberOfLoops = -1
        winPlayer.numberOfLoops = -1
        losePlayer.numberOfLoops = -1
        
        players.append(bgmPlayer)
        players.append(battlePlayer)
        players.append(selectPlayer)
        players.append(divineEffectPlayer)
        players.append(enemyEffectPlayer)
        players.append(winPlayer)
        players.append(losePlayer)
        
        // 起動してすぐにBGMが鳴り出して違和感があるので一旦prepareはしないでおく
        // bgmPlayer.prepareToPlay()
        selectPlayer.prepareToPlay()
    }
    
    func play(_ type: SoundManager.SoundType) {
        switch type {
        case .bgm(let situation):
            switch situation {
            case .hometown:
                bgmPlayer.play()
            case .battle:
                battlePlayer.play()
            }
        case .effect(let unit):
            switch unit {
            case .divine:
                divineEffectPlayer.play()
            case .enemy:
                enemyEffectPlayer.play()
            }
        case .select:
            selectPlayer.play()
        case .result(let result):
            switch result {
            case .win:
                winPlayer.play()
            case .lose:
                losePlayer.play()
            }
        }
    }
    
    func pause(_ type: SoundManager.SoundType) {
        switch type {
        case .bgm(let situation):
            switch situation {
            case .hometown:
                bgmPlayer.pause()
            case .battle:
                battlePlayer.pause()
            }
        case .effect(let unit):
            switch unit {
            case .divine:
                divineEffectPlayer.pause()
            case .enemy:
                enemyEffectPlayer.pause()
            }
        case .select:
            selectPlayer.pause()
        case .result(let result):
            switch result {
            case .win:
                winPlayer.pause()
            case .lose:
                losePlayer.pause()
            }
        }
    }
    
    func stop(_ type: SoundManager.SoundType) {
        switch type {
        case .bgm(let situation):
            switch situation {
            case .hometown:
                bgmPlayer.stop()
            case .battle:
                battlePlayer.stop()
            }
        case .effect(let unit):
            switch unit {
            case .divine:
                divineEffectPlayer.stop()
            case .enemy:
                enemyEffectPlayer.stop()
            }
        case .select:
            selectPlayer.pause()
        case .result(let result):
            switch result {
            case .win:
                winPlayer.stop()
            case .lose:
                losePlayer.stop()
            }
        }
    }
    
    func stopAll() {
        players.forEach { (player) in
            player.currentTime = 0
            player.stop()
        }
//        bgmPlayer.currentTime = 0
//        bgmPlayer.stop()
//        selectPlayer.stop()
//        selectPlayer.currentTime = 0
//        battlePlayer.stop()
//        enemyEffectPlayer.stop()
//        divineEffectPlayer.stop()
//        winPlayer.stop()
//        losePlayer.stop()
    }
}
