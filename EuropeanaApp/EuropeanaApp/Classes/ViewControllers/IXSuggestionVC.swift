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

let kSuggestionCellIdentifier = "suggestionCell"

class IXSuggestionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var data : IXData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = IXData.sharedData()
        // Do any additional setup after loading the view.
        self.collectionView.reloadData()
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
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = data?.pois?.count ?? 0
        return num
    }
    
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kSuggestionCellIdentifier, forIndexPath: indexPath) as! SuggestionViewCell
        cell.poi = self.sortedPois()[indexPath.row]
        
        return cell
    }
}
