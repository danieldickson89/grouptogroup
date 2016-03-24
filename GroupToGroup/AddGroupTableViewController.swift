//
//  AddGroupTableViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class AddGroupTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Properties
    
    var usersGroup: Group?
    var groupsDataSource: [Group] = []
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        setUpSearchController()
    }
    
    func updateView() {
        GroupController.fetchAllGroups { (groups) -> Void in
            self.groupsDataSource = groups.filter({$0.name != self.usersGroup?.name})
            self.tableView.reloadData()
        }
    }


    func setUpSearchController() {
        
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GroupsSearchResultsTableViewController")
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchTerm = searchController.searchBar.text!.lowercaseString
        
        let resultsViewController = searchController.searchResultsController as! GroupsSearchResultsTableViewController
        
        resultsViewController.groupsResultsDataSource = groupsDataSource.filter({$0.name.lowercaseString.containsString(searchTerm)})
        resultsViewController.tableView.reloadData()
    }


    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return groupsDataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath)

        let group = groupsDataSource[indexPath.row]
        cell.textLabel?.text = group.name

        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toGroupProfileView" {
            guard let cell = sender as? UITableViewCell else { return }
            
            if let indexPath = tableView.indexPathForCell(cell) {
                
                let group = groupsDataSource[indexPath.row]
                let usersGroup = self.usersGroup
                
                let destinationViewController = segue.destinationViewController as? GroupProfileViewController
                destinationViewController?.group = group
                destinationViewController?.usersGroup = usersGroup
                
            } else if let indexPath = (searchController.searchResultsController as? GroupsSearchResultsTableViewController)?.tableView.indexPathForCell(cell) {
                
                let group = (searchController.searchResultsController as! GroupsSearchResultsTableViewController).groupsResultsDataSource[indexPath.row]
                let usersGroup = self.usersGroup
                
                let destinationViewController = segue.destinationViewController as? GroupProfileViewController
                destinationViewController?.group = group
                destinationViewController?.usersGroup = usersGroup
            }
        }
    }

}
