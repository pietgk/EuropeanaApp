//
//  IXSuggestionDetailVC.swift
//  ArtWhisper
//
//  Created by Axel Roest on 07/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

import UIKit

enum SuggestionDetailCellType: Int {
    case Caption = 0
    case Date = 1
    case OpeningHours = 2
    case Address = 3
    case URL = 4
    
    static let count: Int = {
        var max: Int = 0
        while let _ = SuggestionDetailCellType(rawValue: ++max) {}
        return max
    }()
    
}

class IXSuggestionDetailVC: UIViewController , UITableViewDataSource, UITableViewDelegate {
    var poi : IXPoi?
    let kDefaultRowHeight : CGFloat  = 44
    let kMaxHeight : CGFloat = 600
    let kCellMargin : CGFloat = 15
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        createLabels()
        // Do any additional setup after loading the view.
        poi?.getImageWithBlock({ (image) -> Void in
            self.imageView.image = image;
        });
        self.navigationTitleItem.title = poi?.name
    }
//
//    override func viewDidAppear(animated: Bool) {
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLabels() {
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SuggestionDetailCellType.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let niceRow = SuggestionDetailCellType(rawValue: indexPath.row)!
        var height: CGFloat
        if (.Caption == niceRow) {
//            (poi?.caption != nil)
            let font = UIFont.systemFontOfSize(13.0)
            let attr = [NSFontAttributeName : font]
            let text = NSAttributedString(string: (poi?.caption)!, attributes: attr)
            let boundSize = CGSizeMake(self.tableView.frame.size.width - kCellMargin, kMaxHeight)
//            let options : NSStringDrawingOptions = [.UsesLineFragmentOrigin | .UsesFontLeading]
            let options = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue |
                NSStringDrawingOptions.UsesFontLeading.rawValue,
                NSStringDrawingOptions.self)
            let rect : CGRect = text.boundingRectWithSize(boundSize, options: options, context: nil)
//            height + additionalHeightBuffer;
            height = rect.size.height + kCellMargin;
            
         } else {
            height = kDefaultRowHeight
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("suggestionDetailCell", forIndexPath: indexPath)
    
    // Configure the cell...
        configureCell(cell, forRow: indexPath.row)
        return cell
    }
    
    func configureCell(cell : UITableViewCell, forRow row: Int) {
        let niceRow = SuggestionDetailCellType(rawValue: row)!
        switch (niceRow) {
        case .Caption :
            cell.imageView?.image = nil
            cell.textLabel?.font = UIFont.systemFontOfSize(13.0)
            cell.textLabel?.text = poi?.caption
        case .Date :
            cell.imageView?.image = IXIcons.iconImageFor(IXIconNameType.icon_calendar, backgroundColor: nil, iconColor: UIColor.blackColor(), fontSize: 24)
            cell.textLabel?.text = "Nov. 28, 2015 - Jan. 17, 2016"
        case .OpeningHours:
            cell.imageView?.image = IXIcons.iconImageFor(IXIconNameType.icon_clock, backgroundColor: nil, iconColor: UIColor.blackColor(), fontSize: 24)
            cell.textLabel?.text = "daily"
        case .Address:
            cell.imageView?.image = IXIcons.iconImageFor(IXIconNameType.icon_map2, backgroundColor: nil, iconColor: UIColor.blackColor(), fontSize: 24)
            cell.textLabel?.text = "venue address"
        case .URL:
            cell.imageView?.image = IXIcons.iconImageFor(IXIconNameType.icon_link, backgroundColor: nil, iconColor: UIColor.blackColor(), fontSize: 24)
           cell.textLabel?.text = self.poi?.venue
            
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
