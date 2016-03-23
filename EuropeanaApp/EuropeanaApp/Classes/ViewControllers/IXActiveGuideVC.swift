//
//  IXActiveGuideVC.swift
//  ArtWhisper
//
//  Created by Axel Roest on 07/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

import UIKit
//@objc protocol IXAudioManagerDelegate

class IXActiveGuideVC: UIViewController , IXAudioManagerDelegate {
    
    var poi : IXPoi? {
        didSet {
            if let p = poi {
                archivePoi()
                self.fillLabels(p)
                self.progressSlider.value = 0
                self.timeLabel.text = "00:00"
                self.watchStartTime = NSDate()
            }
        }
    }
    
    let audioManager = IXAudioManager.sharedAudio()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    var demoParent : Bool = false
    var audioDuration : NSTimeInterval = 0
    var watchStartTime : NSDate?         // when was the poi set?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.poi = IXData.sharedData().mockPoi()
        createLabels()
//        self.fillLabels(self.poi)
        self.timeLabel.text = "00:00"
        self.audioManager.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
//        archivePoi()
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func archivePoi() {
        if self.watchStartTime != nil {
            if let p = self.poi {
                let duration = -((self.watchStartTime?.timeIntervalSinceNow)!)
                let hPoi = IXHistoricPoi(poi:p, date: NSDate(), duration: duration)
                IXData.sharedData().addHistoricPoi(hPoi)
            }
        }
    }
    
    func createLabels() {
        self.titleLabel.font = UIFont.awFontWithSize(13)
        self.artistLabel.font = UIFont.awBoldFontWithSize(12)
        self.captionLabel.font = UIFont.awItalicFontWithSize(11)
        
        togglePlayButton(true)
    }
    
    func fillLabels(poi: IXPoi) {
        // Do any additional setup after loading the view.
        self.titleLabel.text = poi.name
        self.artistLabel.text = poi.artist
        self.captionLabel.text = poi.caption
        self.imageView.backgroundColor = UIColor.darkGrayColor()
        self.imageView.image = nil
        poi.getImageWithBlock({ (image) -> Void in
            self.imageView.image = image;
        });
    }
    // MARK: - AudioManager
    func fadeout() {
        if self.audioManager.audioState == AudioState.audioPlaying {
            self.audioManager.fadeOutBackgroundAudio()
        }
        if self.audioManager.audioState == AudioState.speechPlaying {               // there is no fading of speech yet
            self.audioManager.stop()
        }
    }
    
    func startPlaying() {
        fadeout()
        var succeeded = false
        if let url = poi?.audioURL {
            if self.audioManager.prepareBackgroundPlayerWithFile(url) {
                self.audioManager.tryPlayMusic()
                togglePlayButton(false)
                succeeded = true
            }
        }
        if !succeeded {     // no audio URL
            if let caption = poi?.caption {
                self.audioManager.speak(caption)
                togglePlayButton(false)
            }
            succeeded = true
        }
        if !succeeded {
            self.audioManager.playSystemSound()
        }
    }
        
    func togglePlayButton(play: Bool) {
        if play {
            self.playButton.setAttributedTitle(IXIcons.defaultAttributedIconStringFor(IXIconNameType.icon_play3, size: 24), forState: .Normal)
        } else {
            self.playButton.setAttributedTitle(IXIcons.defaultAttributedIconStringFor(IXIconNameType.icon_pause2, size: 24), forState: .Normal)
        }
    }
    
    @IBAction func playPauseButton(sender: AnyObject) {
        switch self.audioManager.audioState {
        case .audioPlaying , .speechPlaying:
            togglePlayButton(true)
            audioManager.pause()        // stop playing
            // change button
            // stop timer
        case .audioPaused, .speechPaused:
            togglePlayButton(false)
            self.audioManager.resume()        // continues
        case .silent:
            self.startPlaying()
        }
    }
    
    func playing() -> Bool {
        return self.audioManager.audioState == AudioState.audioPlaying || self.audioManager.audioState == AudioState.speechPlaying
    }
    
    // if the user interacts with the slider
    @IBAction func updateProgress(sender: UISlider) {
        // update audio player accordingly (if possible)
        // TODO: we need to maybe store the index locally, in case the audio is stopped while we're sliding. Then when we hit play we should check if the user set the starting point
        if (self.audioManager.audioState == .audioPlaying) {
            let timeIndex = Double(sender.value) * self.audioDuration
            self.audioManager.setAudioCurrentTime(timeIndex)
        }
    }
    
    // MARK: - IXAudioManagerDelegate
    func audioManager(audioManager: IXAudioManager!, progress: Float)
    {
        self.progressSlider.setValue(progress, animated: true)
        // update label
        updateTimeLabel(progress)
    }

    func audioManager(audioManager: IXAudioManager!, totalDuration: NSTimeInterval) {
        self.audioDuration = totalDuration
        updateTimeLabel(0)
    }
    
    func updateTimeLabel(progress : Float) {
        let timeStr = NSDate.durationInMinutesAndSeconds(( NSTimeInterval(progress) - 1) * self.audioDuration)
        self.timeLabel.text = timeStr
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func back(sender:AnyObject) {
        if demoParent {
            self.performSegueWithIdentifier("unwindActiveDemoSegue", sender: self)
        } else {
            self.performSegueWithIdentifier("unwindDetailSegue", sender: self)
        }
    }
    
    @IBAction func nextMocker(sender: AnyObject) {
        self.audioManager.stop()
        togglePlayButton(true)
        self.poi = IXData.sharedData().mockPoi()        // get new value
    }

    @IBAction func previousMocker(sender: AnyObject) {
        self.audioManager.stop()
        togglePlayButton(true)
        self.poi = IXData.sharedData().previousMockPoi()        // get new value
    }

}