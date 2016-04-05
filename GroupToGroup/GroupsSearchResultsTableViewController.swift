//
//  GroupsSearchResultsTableViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/23/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class GroupsSearchResultsTableViewController: UITableViewController {
    
    var groupsResultsDataSource: [Group] = []

    override func viewWillAppear(animated: Bool) {
        view.backgroundColor = UIColor.chatListBackgroundColor()
        tableView.backgroundColor = UIColor.chatListBackgroundColor()
        self.navigationController?.navigationBar.tintColor = UIColor.myGreenColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.toolbar.barTintColor = UIColor.myNavBarTintColor()
        self.navigationController?.setToolbarHidden(true, animated: true)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsResultsDataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupnameCell", forIndexPath: indexPath)
        
        let group = groupsResultsDataSource[indexPath.row]
        
        cell.textLabel?.text = group.name
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.chatListBackgroundColor()
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.presentingViewController?.performSegueWithIdentifier("toGroupProfileView", sender: cell)
    }

}
