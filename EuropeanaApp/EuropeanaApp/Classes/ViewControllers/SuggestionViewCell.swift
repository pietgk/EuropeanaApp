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

    var poi : IXPoi? {
        didSet {
            // TODO: add properties to IXPoi
            if let title = poi!.name {
                self.artistLabel.text = title
            }
            if let title = poi!.name {
                self.titleLabel.text = title
            }
            if let title = poi!.name {
                self.venueLabel.text = title
            }
        }
    }
}