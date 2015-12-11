//
//  IXActiveGuideVC.swift
//  ArtWhisper
//
//  Created by Axel Roest on 07/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

import UIKit

class IXActiveGuideVC: UIViewController {
    
    var poi : IXPoi?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    var playing : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLabels()
        // Do any additional setup after loading the view.
        self.titleLabel.text = poi?.name
        self.artistLabel.text = poi?.artist
        self.captionLabel.text = poi?.caption
        self.imageView.backgroundColor = UIColor.darkGrayColor()
        self.imageView.image = nil
        poi?.getImageWithBlock({ (image) -> Void in
            self.imageView.image = image;
        });
        
        self.timeLabel.text = "00:00"
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
    
    func togglePlayButton(play: Bool) {
        if play {
            self.playButton.setAttributedTitle(IXIcons.defaultAttributedIconStringFor(IXIconNameType.icon_play3, size: 24), forState: .Normal)
            self.playing = true
        } else {
            self.playButton.setAttributedTitle(IXIcons.defaultAttributedIconStringFor(IXIconNameType.icon_pause2, size: 24), forState: .Normal)
            self.playing = false
        }
    }
    
    @IBAction func playPauseButton(sender: AnyObject) {
        if self.playing {
            togglePlayButton(false)
            // stop playing
            // change button
            // stop timer
        } else {
            togglePlayButton(true)
        }
    }
    
    // if the user interacts with the slider
    @IBAction func updateProgress(sender: UISlider) {
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}