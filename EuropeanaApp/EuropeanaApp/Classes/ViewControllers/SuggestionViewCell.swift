//
//  SuggestionViewCell.swift
//  ArtWhisper
//
//  Created by Axel Roest on 20/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

import Foundation
//import IXPoi

class SuggestionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var waitView: UIView!    // custom

    public var poi : IXPoi?
    
    func setPoi(newPoi: IXPoi) {
        self.poi = newPoi
        // TODO: add properties to IXPoi
        if let title = newPoi.name {
            self.artistLabel = title
        }
        if let title = newPoi.name {
            self.titleLabel = title
        }
        if let title = newPoi.name {
            self.venueLabel = title
        }
    }
}