//
//  ProjectsController.swift
//  BitAuth
//
//  Created by Dino Trojak on 04/12/14.
//  Copyright (c) 2014 Dino Trojak. All rights reserved.
//

import UIKit

class ProjectsController: UITableViewController {
    var repos = [NSDictionary]()
    var selected = NSDictionary()
    var sections: NSArray = NSArray()
    @IBOutlet weak var tit: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        var parameters =  Dictionary<String, AnyObject>()

        oauthswift.client.get("https://bitbucket.org/api/1.0/user/repositories/dashboard/", parameters: parameters,
            success: {
                data, response in
                self.repos.removeAll(keepCapacity: true)
                let response: NSArray! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                let me:NSArray = response[0] as NSArray
                
                user = me[0] as NSDictionary
                println(response)
                var title = user["first_name"] as String
                    title += "'s repositories"
                self.tit.title = title
                
                self.sections = response
                for rep in response{
                    let reps = rep[1] as NSArray
                    for proj in reps{
                        self.repos.append(proj as NSDictionary)
                    }
                }
                self.tableView.reloadData()

            }, failure: {(error:NSError!) -> Void in
                println(error)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return sections.objectAtIndex(section)[1].count
    }
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

            let row: NSDictionary = self.sections[indexPath.section][1][indexPath.row] as NSDictionary
            
            let text = row["name"] as NSString
            cell.textLabel.text = text
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row: NSDictionary = self.sections[indexPath.section][1][indexPath.row] as NSDictionary
        self.selected = row
        self.performSegueWithIdentifier("pushDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "pushDetail") {
            var detailVC = segue.destinationViewController as RepoController;
            detailVC.repo = self.selected
        }
    }
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String {
            return self.sections[section][0]["display_name"] as NSString
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
