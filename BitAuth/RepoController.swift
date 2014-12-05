//
//  RepoController.swift
//  BitAuth
//
//  Created by Dino Trojak on 04/12/14.
//  Copyright (c) 2014 Dino Trojak. All rights reserved.
//

import UIKit

class RepoController: UITableViewController {
    var repo = NSDictionary()
    let me = user["username"] as NSString
    var issues: NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.issues = response["issues"] as NSArray
                self.tableView.reloadData()

                
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
        
        var bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.redColor()
        cell.selectedBackgroundView = bgColorView
        
        return cell
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
