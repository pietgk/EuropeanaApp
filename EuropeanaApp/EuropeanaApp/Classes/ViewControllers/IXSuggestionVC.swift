//
//  IXSuggestionVC.swift
//  ArtWhisper
//
//  Created by Axel Roest on 07/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//
/* Overview of suggestions

*/
import UIKit
//import IXData
//import SuggestionViewCell

enum segues: String {
    case showSuggestionDetail = "showSuggestionDetail"
}

class IXSuggestionVC: UICollectionViewController {
    
    private let kSuggestionCellIdentifier = "suggestionCell"
    // @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    var data : IXData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.navigationBackground()
        data = IXData.sharedData()
        self.collectionView?.backgroundColor = UIColor.darkGrayBackground()
        // Do any additional setup after loading the view.
        self.collectionView?.reloadData()
        
//        for family: String in UIFont.familyNames()
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNamesForFamilyName(family)
//            {
//                print("== \(names)")
//            }
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func unwindDetail(segue: UIStoryboardSegue) {
        NSLog("unwinding")
    }
    
    func sortedPois() -> Array<IXPoi> {
        // let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let pois = data?.pois?.sort({poi1, poi2 in return poi1.name > poi2.name }) ?? Array<IXPoi>()
        return pois
    }
    
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kSuggestionCellIdentifier, forIndexPath: indexPath) as! SuggestionViewCell
        cell.poi = self.sortedPois()[indexPath.row]
        cell.backgroundColor = UIColor.whiteBackground()
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segues.showSuggestionDetail.rawValue) {
            let cell = sender as! SuggestionViewCell
            let destinationVC = segue.destinationViewController as! IXSuggestionDetailVC
            destinationVC.poi = cell.poi
        }
    }

}

// MARK: - UICollectionViewDataSource
extension IXSuggestionVC {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = data?.pois?.count ?? 0
        return num
    }

}

extension IXSuggestionVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSizeMake(145, 225)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
}

