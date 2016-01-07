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
                self.fillLabels(p)
                self.playing = false
                self.progressSlider.value = 0
                self.timeLabel.text = "00:00"
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
    
    var playing : Bool = false
    var demoParent : Bool = false
    var audioDuration : NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.poi = IXData.sharedData().mockPoi()
        createLabels()
//        self.fillLabels(self.poi)
        self.timeLabel.text = "00:00"
        self.audioManager.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func fadeout() {
        if self.playing {
            self.audioManager.fadeOutBackgroundAudio()
            self.playing = false
        }
    }
    
    func startPlaying() {
        fadeout()
        self.audioManager.prepareBackgroundPlayerWithFile(poi?.audioURL)
        self.audioManager.tryPlayMusic()
        togglePlayButton(false)
        
    }
        
    func togglePlayButton(play: Bool) {
        if play {
            self.playButton.setAttributedTitle(IXIcons.defaultAttributedIconStringFor(IXIconNameType.icon_play3, size: 24), forState: .Normal)
            self.playing = false
        } else {
            self.playButton.setAttributedTitle(IXIcons.defaultAttributedIconStringFor(IXIconNameType.icon_pause2, size: 24), forState: .Normal)
            self.playing = true
        }
    }
    
    @IBAction func playPauseButton(sender: AnyObject) {
        if self.playing {
            togglePlayButton(true)
            audioManager.pause()        // stop playing
            // change button
            // stop timer
        } else {
            togglePlayButton(false)
            if (self.audioManager.audioState == AudioState.audioPaused) {
            // cannot use startPlaying here
                self.audioManager.resume()        // continues
            } else {
                self.startPlaying()
            }
        }
    }
    
    // if the user interacts with the slider
    @IBAction func updateProgress(sender: UISlider) {
        // update audio player accordingly (if possible)
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
        let timeStr = DateUtilities.durationInMinutesAndSeconds(( NSTimeInterval(progress) - 1) * self.audioDuration)
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