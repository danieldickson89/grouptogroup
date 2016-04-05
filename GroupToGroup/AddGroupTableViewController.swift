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
    
    override func viewWillAppear(animated: Bool) {
        view.backgroundColor = UIColor.chatListBackgroundColor()
        tableView.backgroundColor = UIColor.chatListBackgroundColor()
        self.navigationController?.navigationBar.tintColor = UIColor.myGreenColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.toolbar.barTintColor = UIColor.myNavBarTintColor()
        self.navigationController?.setToolbarHidden(true, animated: true)
        
    }
    
    func updateView() {
        
        if let usersGroup = usersGroup {
            GroupController.fetchAllGroups(usersGroup, completion: { (groups) in
                if let groups = groups {
                    self.groupsDataSource = groups.sort({$0.name < $1.name})
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    
    func setUpSearchController() {
        
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GroupsSearchResultsTableViewController")
        
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barStyle = .BlackTranslucent
        searchController.searchBar.tintColor = UIColor.myGreenColor()
        searchController.searchBar.keyboardAppearance = .Dark
        tableView.tableHeaderView = searchController.searchBar
        
        
        if let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.whiteColor()
        }
        
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
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.chatListBackgroundColor()
        
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
