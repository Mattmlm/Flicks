//
//  MainViewController.swift
//  Flicks
//
//  Created by Kevin Rajan on 1/12/16.
//  Copyright © 2016 veeman961. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var containerViewController: ContainerViewController?
    
    var count: Int = 0
    var checked: [[Bool]]!
    var checkedKey:String = "CHECKED_CATEGORIES"
    let CellIdentifier = "CategoryCell"
    
    let categories = [["Now Playing","Popular","Top Rated", "Upcoming"],["On the Air", "Airing Today", "Top Rated", "Popular"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidEnterBackground", name: "appDidEnterBackground", object: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        self.navigationController?.navigationBar.barStyle = .BlackTranslucent
        
        
        //Configures checked: [[Bool]]
        let defaults = NSUserDefaults.standardUserDefaults()
        self.checked = defaults.objectForKey(checkedKey) as! [[Bool]]
        print(self.checked)

        for i in 0 ..< checked.count {
            for j in 0 ..< checked[i].count {
                if (checked[i][j]) {
                    ++count
                }
                print(count)
            }
        }

    }
    
    func appDidEnterBackground() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(checked, forKey: checkedKey)
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView - Configure the UITableView
    
    // tableview contains 2 sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categories.count
        
    }
    // title for each section
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Movie Categories"
        }
        else {
            return "TV Show Categories"
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor()
        header.textLabel!.textColor = UIColor.whiteColor()
        header.alpha = 0.55
    }
    
    // numberOfRowsInSection
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].count
    }
    // didselectrow
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell")!
        checked[indexPath.section][indexPath.row] = !(checked[indexPath.section][indexPath.row])
        if checked[indexPath.section][indexPath.row] {
            cell.accessoryType = .Checkmark
            ++count
        }
        else {
            cell.accessoryType = .None
            --count
        }
        if count == 4 {
            tableViewHandler(self.tableView,  maxChecked: true)
        }
        else {
            tableViewHandler(self.tableView,  maxChecked: false)
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        if (containerViewController != nil) {
            containerViewController!.checked = self.checked
        }
        
        //containerViewController.reloadInputViews()
        //containerViewController.prepareForSegue(UIStoryboardSegue(identifier: "tabBarEmbed", source: containerViewController, destination: tabVC), sender: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell")!
        
        cell.textLabel?.text = categories[indexPath.section][indexPath.row]
        
        cell.backgroundColor = UIColor.darkGrayColor()
        cell.tintColor = UIColor.orangeColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        if count == 4 {
            if checked[indexPath.section][indexPath.row] {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
                disableCell(cell)
            }
        }
        else {
            if checked[indexPath.section][indexPath.row] {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
        }
        return cell
    }
    
    // MARK: Helper methods
    
    func disableCell(cell: UITableViewCell) {
        cell.userInteractionEnabled = false
        cell.backgroundColor = UIColor.blackColor()
    }
    
    func enableCell(cell: UITableViewCell) {
        cell.backgroundColor = UIColor.darkGrayColor()
        cell.userInteractionEnabled = true
        
    }
    
    func tableViewHandler(tableView: UITableView, maxChecked: Bool) {
        if maxChecked {
            for i in 0 ..< checked.count {
                for j in 0 ..< checked[i].count {
                    if !(checked[i][j]) {
                        disableCell(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i))!)
                    }
                }
            }
        }
        else {
            for i in 0 ..< checked.count {
                for j in 0 ..< checked[i].count {
                    enableCell(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i))!)
                }
            }
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
