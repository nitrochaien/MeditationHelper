//
//  ClockViewModel.swift
//  MeditationHelper
//
//  Created by Dinh Vu Nam on 7/27/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit
import AVFoundation

class ClockViewModel {
    var player: AVAudioPlayer?
    var timer: Timer?
    var timeCount = 0
    
    static let model = ClockViewModel()
    static let updateTimer = Notification.Name("updateTimer")
    
    func preparePlayer() {
        prepareAudioSession()
        prepareToPlay()
    }
    
    func prepareAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func prepareToPlay() {
        let url = Bundle.main.url(forResource: "clockticking_with_silence", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            try AVAudioSession.sharedInstance().setCategory("AVAudioSessionCategoryPlayback")
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            player.numberOfLoops = -1
            player.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func timeEllapsed() -> String {
        var value = ""
        timePassed(completion: { hours, minutes, seconds in
            let hours = self.getStringFrom(seconds: hours)
            let minutes = self.getStringFrom(seconds: minutes)
            let seconds = self.getStringFrom(seconds: seconds)
            
            value = "Time passed: \(hours):\(minutes):\(seconds)"
        })
        return value
    }
    
    func timePassed(completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        completion(self.timeCount / 3600, (self.timeCount % 3600) / 60, (self.timeCount % 3600) % 60)
    }
    
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    func refreshTimer() {
        timeCount = 0
    }
    
    func stopPlayingSound() {
        timer?.invalidate()
        player?.stop()
        refreshTimer()
    }
    
    func pausePlayingSound()
    {
        self.player?.pause()
        timer?.invalidate()
    }
    
    func startPlayingSound() {
        if #available(iOS 10.0, *) {
            self.player?.play()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
                self.timeCount += 1
                print("Time count: ", self.timeCount)
                NotificationCenter.default.post(name: ClockViewModel.updateTimer, object: nil, userInfo: nil)
            })
        } else {
            
        }
    }
    
    func adjustVolume(_ value: CGFloat) {
        if (self.player?.volume)! < Float.init(0) {
            self.player?.volume = 0
            return
        } else if (self.player?.volume)! > Float.init(1) {
            self.player?.volume = 1
            return
        }
        print("volume: \(String(describing: self.player?.volume))")
        if value > 0 {
            self.player?.volume -= 0.01
        } else {
            self.player?.volume += 0.01
        }
    }
    
    func mute() {
        self.player?.volume = 0
    }
    
    func enableSound() {
        self.player?.volume = 1
    }
}
