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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        createLabels()
        // Do any additional setup after loading the view.
        poi?.getImageWithBlock({ (image) -> Void in
            self.imageView.image = image;
        });
        
    }
    
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
                cell.textLabel?.text = poi?.caption
        case .Date :
                cell.textLabel?.text = "nu"
        case .OpeningHours:
                cell.textLabel?.text = "de hele dag"
        case .Address:
            cell.textLabel?.text = "venue address"
        case .URL:
            cell.textLabel?.text = "http://www.google.com"
            
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
