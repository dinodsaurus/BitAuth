//
//  RepoController.swift
//  BitAuth
//
//  Created by Dino Trojak on 04/12/14.
//  Copyright (c) 2014 Dino Trojak. All rights reserved.
//

import UIKit

class RepoController: UITableViewController, UIActionSheetDelegate {
    var repo = NSDictionary()
    let me = user["username"] as NSString
    var issues: NSArray = NSArray()

    @IBOutlet weak var detailTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))

        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray

        self.detailTitle.title = repo["name"] as NSString
        
        self.tableView.hidden = false
        let owner = repo["owner"] as NSString
        let slug = repo["slug"] as NSString
        var parameters =  Dictionary<String, AnyObject>()
        parameters = ["sort":"kind", "status":"new", "responsible": me]
        
        
        let url: NSString = "https://bitbucket.org/api/1.0/repositories/\(owner)/\(slug)/issues/"

        oauthswift.client.get(url, parameters: parameters,
            success: {
                data, response in
                let response: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                println(response)
                //self.activityIndicator.stopAnimating()
                self.issues = response["issues"] as NSArray
                
                if(self.issues.count > 0){
                    self.tableView.hidden = false

                    self.tableView.reloadData()

                }

                
            }, failure: {(error:NSError!) -> Void in
                println(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.issues.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let row: AnyObject = self.issues[indexPath.row]
        let text = row["title"] as NSString
        cell.textLabel.text = text
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let actionSheet = UIActionSheet(title: "ActionSheet", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Done", otherButtonTitles: "Yes", "No")
        actionSheet.showInView(self.view)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
