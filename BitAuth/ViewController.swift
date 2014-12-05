//
//  ViewController.swift
//  BitAuth
//
//  Created by Dino Trojak on 01/12/14.
//  Copyright (c) 2014 Dino Trojak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a ewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func login(sender: AnyObject) {
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/bitbucket")!, success: {
            credential, response in
            
            self.performSegueWithIdentifier("jumpToRepos", sender: self)
            
            }, failure: {(error:NSError!) -> Void in
                println("doesntWork")
        })
    }
}

