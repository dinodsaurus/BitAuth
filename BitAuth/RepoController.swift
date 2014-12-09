//
//  RepoController.swift
//  BitAuth
//
//  Created by Dino Trojak on 04/12/14.
//  Copyright (c) 2014 Dino Trojak. All rights reserved.
//

import UIKit

class RepoController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {
    var repo = NSDictionary()
    let me = user["username"] as NSString
    var issues: NSArray = NSArray()
    var active: NSDictionary = NSDictionary()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var detailTitle: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noItems: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.detailTitle.title = repo["name"] as NSString
        
        let owner = repo["owner"] as NSString
        let slug = repo["slug"] as NSString
        var parameters =  Dictionary<String, AnyObject>()
        
        parameters = ["sort":"kind", "status":"new", "responsible": me]
        
        let url: NSString = "https://bitbucket.org/api/1.0/repositories/\(owner)/\(slug)/issues/"

        oauthswift.client.get(url, parameters: parameters,
            success: {
                data, response in
                let response: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                self.issues = response["issues"] as NSArray

                //self.activityIndicator.stopAnimating()
                println(self.issues)
                self.activityIndicator.stopAnimating()
                if(self.issues.count > 0){
                    self.noResultView.removeFromSuperview()
                    self.tableView.reloadData()

                }else{
                    self.noItems.hidden = false
                }

                
            }, failure: {(error:NSError!) -> Void in
                //self.activityIndicator.stopAnimating()
                println(error)
                self.activityIndicator.stopAnimating()
                self.noItems.hidden = false


        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.issues.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let row: AnyObject = self.issues[indexPath.row]
        let text = row["title"] as NSString
        cell.textLabel.text = text
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let actionSheet = UIActionSheet(title: "What to do ?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Resolve", otherButtonTitles: "Comment")
        self.active = self.issues[indexPath.row] as NSDictionary
        println(active)
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int){
        switch buttonIndex{
            case 0:
                var parameters =  Dictionary<String, AnyObject>()
                parameters = ["status":"resolved"]
                
                let id:NSInteger = active["local_id"] as NSInteger
                let owner = repo["owner"] as NSString
                let slug = repo["slug"] as NSString
                let url: NSString = "https://bitbucket.org/api/1.0/repositories/\(owner)/\(slug)/issues/\(id)/"
                oauthswift.client.put(url, parameters: parameters,
                    success: {
                        data, response in
                        let response: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                        println(response)
                        
                    }, failure: {(error:NSError!) -> Void in
                        println(error)
                })
                break;
            case 2:
                NSLog("Comment");
                break;
            default:
                NSLog("Cancle");
                break;
        }

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
