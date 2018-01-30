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

    @IBOutlet var btnStart: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet weak var viewStop: UIView!
    @IBOutlet weak var btnPause: UIButton!
    
    var navBarHairlineImageView: UIImageView!
    
    var circleView: CircleView?
    var state: State!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        navBarHairlineImageView = findHairlineImageViewUnder(view: (self.navigationController?.navigationBar)!)
        
        btnStart.setTitle("Start", for: .normal)
        ClockViewModel.model.preparePlayer()
        
        customNavigation()
        addGesture()
        
        handleSound()
        
        state = .stopped
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onFontChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    func onFontChange()
    {
        print("Changed font")
        let pointSize  = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
        let customFont = UIFont(name: "HelveticaNeue", size: pointSize)
        
        labelTime.font = customFont
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
    
    fileprivate func showViewStop() {
        btnStart.isHidden = true
        viewStop.isHidden = false
        view.bringSubview(toFront: viewStop)
    }
    
    fileprivate func updateUIWhenStartPlayingSound() {
        if let isHideTimer = UserDefaults.standard.object(forKey: "IsHideTimer") as? Bool {
            labelTime.isHidden = isHideTimer
        } else {
            labelTime.isHidden = false
        }
        
        handleSound()
        showViewStop()
    }
    
    fileprivate func handleSound() {
        if let enableSound = UserDefaults.standard.object(forKey: "IsSoundEnable") as? Bool {
            if enableSound {
                ClockViewModel.model.enableSound()
            } else {
                ClockViewModel.model.mute()
            }
        } else {
            ClockViewModel.model.mute()
        }
    }
    
    fileprivate func hideViewStop() {
        btnStart.isHidden = false
        viewStop.isHidden = true
        view.bringSubview(toFront: btnStart)
    }
    
    fileprivate func updateUIWhenStopPlayingSound() {
        labelTime.isHidden = false
        hideViewStop()
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
        guard state == .stopped else {
            alert(message: "Please stop meditating first!")
            return
        }
        let settingsController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsController")
        navigationController?.pushViewController(settingsController, animated: true)
    }
    
    @IBAction func onClickStop(_ sender: Any)
    {
        state = .stopped
        ClockViewModel.model.stopPlayingSound()
        updateUIWhenStopPlayingSound()
    }
    
    @IBAction func onClickPause(_ sender: Any)
    {
        if state == .medicating
        {
            state = .paused
            ClockViewModel.model.pausePlayingSound()
            btnPause.setTitle("Continue", for: .normal)
        }
        else if state == .paused
        {
            state = .medicating
            ClockViewModel.model.startPlayingSound()
            updateUIWhenStartPlayingSound()
            btnPause.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func onClickStart(_ sender: Any) {
        state = .medicating
        ClockViewModel.model.startPlayingSound()
        TimeCalculator.time.saveTime()
        updateUIWhenStartPlayingSound()
    }
}
