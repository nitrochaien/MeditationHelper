//
//  ClockViewController.swift
//  MeditationHelper
//
//  Created by Dinh Vu Nam on 7/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit
import AVFoundation

class ClockViewController: UIViewController {

    var player: AVAudioPlayer?
    var isRunning = false
    var timer: Timer?
    var timeCount = 0
    @IBOutlet var button: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var labelTime: UILabel!
    
    var circleView: CircleView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        button.setTitle("Start", for: .normal)
        
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
        
        playSound()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeView), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "clockticking", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onClick(_ sender: Any)
    {
        //is running
        if isRunning
        {
            button.setTitle("Start", for: .normal)
            timer?.invalidate()
            player?.stop()
            showTime()
            refreshTime()
        }
        else
        {
            button.setTitle("Stop", for: .normal)
            if #available(iOS 10.0, *) {
                self.player?.play()
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
                    self.player?.play()
                    self.timeCount += 1
                })
            } else {
                
            }
        }
        isRunning = !isRunning
        labelTime.isHidden = isRunning
    }
    
    func showTime() {
        timePassed(completion: { hours, minutes, seconds in
            let hours = self.getStringFrom(seconds: hours)
            let minutes = self.getStringFrom(seconds: minutes)
            let seconds = self.getStringFrom(seconds: seconds)
            
            self.labelTime.text = "Time passed: \(hours):\(minutes):\(seconds)"
        })
    }
    
    func timePassed(completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        completion(self.timeCount / 3600, (self.timeCount % 3600) / 60, (self.timeCount % 3600) % 60)
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    func refreshTime() {
        timeCount = 0
    }
    
    func reloadView()
    {
        circleView = CircleView(frame: CGRect.init(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        contentView.addSubview(circleView!)
    }
    
    func removeView()
    {
        circleView?.removeFromSuperview()
        circleView = nil
    }
}
