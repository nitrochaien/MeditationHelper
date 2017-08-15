//
//  ClockViewController.swift
//  MeditationHelper
//
//  Created by Dinh Vu Nam on 7/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ClockViewController: UIViewController {

    @IBOutlet var button: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var labelTime: UILabel!
    
    var navBarHairlineImageView: UIImageView!
    
    var circleView: CircleView?
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        navBarHairlineImageView = findHairlineImageViewUnder(view: (self.navigationController?.navigationBar)!)
        
        button.setTitle("Start", for: .normal)
        ClockViewModel.model.preparePlayer()
        
        customNavigation()
        addGesture()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navBarHairlineImageView?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        navBarHairlineImageView?.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeView), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimer), name: ClockViewModel.updateTimer, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: ClockViewModel.updateTimer, object: nil)
    }
    
    func customNavigation() {
        let settingsButton = UIBarButtonItem.init(title: "Settings", style: .plain, target: self, action: #selector(goToSettings))
        navigationItem.rightBarButtonItem = settingsButton
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func addGesture() {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(pan)
    }
    
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let y = gesture.velocity(in: view).y
        ClockViewModel.model.adjustVolume(y)
    }
    
    @IBAction func onClick(_ sender: Any) {
        if isRunning {
            button.setTitle("Start", for: .normal)
            ClockViewModel.model.stopPlayingSound()
            labelTime.isHidden = false
        } else {
            button.setTitle("Stop", for: .normal)
            ClockViewModel.model.startPlayingSound()
            TimeCalculator.time.saveTime()
            if let isHideTimer = UserDefaults.standard.object(forKey: "IsHideTimer") as? Bool {
                labelTime.isHidden = isHideTimer
                print("Has userstandard value")
            } else {
                labelTime.isHidden = false
                print("Not have userstandard value")
            }
        }
        isRunning = !isRunning
    }
    
    func updateTimer() {
        labelTime.text = ClockViewModel.model.timeEllapsed()
    }
    
    func reloadView() {
        circleView = CircleView(frame: CGRect.init(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        contentView.addSubview(circleView!)
    }
    
    func removeView() {
        circleView?.removeFromSuperview()
        circleView = nil
    }
    
    func goToSettings() {
        guard !isRunning else {
            alert(message: "Please stop meditating first!")
            return
        }
        let settingsController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController")
        navigationController?.pushViewController(settingsController, animated: true)
    }
}
