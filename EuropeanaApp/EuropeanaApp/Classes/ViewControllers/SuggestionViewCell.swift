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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {
        setupLabels()
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
        self.imageView.image = nil
    }
    
    var poi : IXPoi? {
        didSet {
            // TODO: add properties to IXPoi
            if let title = poi!.name {
                self.artistLabel.text = title
            } else {
                self.artistLabel.text = ""
            }
            if let title = poi!.caption {
                self.titleLabel.text = title
            } else {
                self.titleLabel.text = ""
            }
            if let title = poi!.name {
                self.venueLabel.text = title
            } else {
                self.venueLabel.text = ""
            }

            self.poi?.getImageWithBlock({ (image) -> Void in
                self.imageView.image = image;
            })
            
        }
    }
}