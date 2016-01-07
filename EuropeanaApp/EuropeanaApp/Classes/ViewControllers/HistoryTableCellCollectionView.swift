//
//  HistoryTableCellCollectionView.swift
//  ArtWhisper
//
//  Created by Axel Roest on 07/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

/* The tableviewcell with horizontal collection scrollview
*/

import Foundation

class  HistoryTableCellCollectionView : UITableViewCell {
    
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func prepareForReuse() {
        setupLabels()
        venueLabel.text = "Amsterdam Lite Festival"
    }

    func setupLabels() {
        self.venueLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
        self.dateLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
    }
    
    func configureWithHistoricPoi(hPoi : IXHistoricPoi) {
        if let p = hPoi.poi {
            self.venueLabel.text = p.name ?? ""
        } else {
            self.venueLabel.text = ""
        }
        self.dateLabel.text = hPoi.visitDate?.description
        
    }
}