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
        let url = Bundle.main.url(forResource: "clockticking", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
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
    }
    
    func startPlayingSound() {
        if #available(iOS 10.0, *) {
            self.player?.play()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
                self.player?.play()
                self.timeCount += 1
            })
        } else {
            
        }

    }
}
