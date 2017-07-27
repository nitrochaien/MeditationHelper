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

    @IBOutlet var button: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var labelTime: UILabel!
    
    var circleView: CircleView?
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.setTitle("Start", for: .normal)
        ClockViewModel.model.preparePlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeView), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
        //is running
        if isRunning {
            button.setTitle("Start", for: .normal)
            ClockViewModel.model.stopPlayingSound()
            labelTime.text = ClockViewModel.model.timeEllapsed()
            ClockViewModel.model.refreshTimer()
        } else {
            button.setTitle("Stop", for: .normal)
            ClockViewModel.model.startPlayingSound()
            TimeCalculator.time.saveTime()
        }
        isRunning = !isRunning
        labelTime.isHidden = isRunning
    }
    
    func reloadView() {
        circleView = CircleView(frame: CGRect.init(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        contentView.addSubview(circleView!)
    }
    
    func removeView() {
        circleView?.removeFromSuperview()
        circleView = nil
    }
}
