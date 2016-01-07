//
//  SuggestionViewCell.swift
//  ArtWhisper
//
//  Created by Axel Roest on 20/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

import Foundation
import UIKit
//import IXPoi

class SuggestionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var waitView: UIView!    // custom
    @IBOutlet weak var timeLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//    == HelveticaNeue-Italic
//    == HelveticaNeue-Bold
//    == HelveticaNeue-UltraLight
//    == HelveticaNeue-CondensedBlack
//    == HelveticaNeue-BoldItalic
//    == HelveticaNeue-CondensedBold
//    == HelveticaNeue-Medium
//    == HelveticaNeue-Light
//    == HelveticaNeue-Thin
//    == HelveticaNeue-ThinItalic
//    == HelveticaNeue-LightItalic
//    == HelveticaNeue-UltraLightItalic
//    == HelveticaNeue-MediumItalic
//    == HelveticaNeue

    func setupLabels() {
        self.artistLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 10.0)
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Italic", size: 10.0)
        self.venueLabel.font = UIFont(name: "HelveticaNeue", size: 10.0)
    }
    
    override func prepareForReuse() {
        setupLabels()
        self.imageView.image = nil
    }
    
    var poi : IXPoi? {
        didSet {
            // TODO: add properties to IXPoi
            if let title = poi!.artist {
                self.artistLabel.text = title
            } else {
                self.artistLabel.text = ""
            }
            if let title = poi!.name {
                self.titleLabel.text = title
            } else {
                self.titleLabel.text = ""
            }
            if let title = poi!.venue {
                self.venueLabel.text = title
            } else {
                self.venueLabel.text = ""
            }

            self.poi?.getImageWithBlock({ (image) -> Void in
                self.imageView.image = image;
            })
            
            loadTimeLabel()
        }
    }
    
    // set the time label, will be a custom view later
    func loadTimeLabel() {
        var timeString : String
        timeString = IXIcons.iconStringFor(.icon_stopwatch)
        let manStr = IXIcons.iconStringFor(.icon_man)
        let man : Character = manStr.characters[manStr.startIndex]
        let men = String(count: Int(arc4random_uniform(4) + 1), repeatedValue: man)
        timeLabel.font = UIFont.iconFontWithSize(20)
        timeLabel.text = timeString + " " + men
        
    }
}