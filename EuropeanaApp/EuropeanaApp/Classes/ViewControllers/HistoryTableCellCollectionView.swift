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

class  HistoryTableCellCollectionView : UITableViewCell , UICollectionViewDataSource, UICollectionViewDelegate {
    private let kHistoryCellIdentifier = "historyCell"

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

// MARK: - UICollectionViewDataSource
extension HistoryTableCellCollectionView {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = IXData.sharedData().historicPois?.count ?? 0
        return num
    }
    
}

// MARK: - UICollectionViewDelegate
extension HistoryTableCellCollectionView {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kHistoryCellIdentifier, forIndexPath: indexPath)
        if let hPoi = IXData.sharedData().historicPois?[indexPath.row] {
            // let hPoi2 = hPoi as! IXHistoricPoi
            if let poi = hPoi.poi {
                if let image = poi!.image {
                    let imageView = UIImageView.init(image: image)
                    imageView.frame = cell.contentView.bounds
                    imageView.contentMode = .ScaleAspectFill
                    cell.contentView.addSubview(imageView)
                }
            }
        }
        cell.backgroundColor = UIColor.yellowColor()
        return cell
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segues.showSuggestionDetail.rawValue) {
            let cell = sender as! SuggestionViewCell
            let destinationVC = segue.destinationViewController as! IXSuggestionDetailVC
            destinationVC.poi = cell.poi
            //            destinationVC.poi = IXPoi.mockPoi()
            
        }
    }

}

//extension IXSuggestionVC : UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//            return cellSizeForThisDevice
//            //            return CGSizeMake(140, 266)
//            //            return CGSizeMake(164, 266)
//    }
//    
//    func collectionView(collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//            return sectionInsets
//    }
//    
//}

