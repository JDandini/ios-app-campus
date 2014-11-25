//
//  MenuLateral.swift
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 12/11/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

import UIKit

@objc protocol MenuLateralDelegate{
    optional func optionSelectioned(option: String)
}

class MenuLateral: UITableViewController {
    // propiedad delegado de la clase
    weak var delegate: MenuLateralDelegate?
    let optsArray = ["Noticias","Reportear"]
    var indexSelected: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.scrollsToTop = false
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: - Table view data source
extension MenuLateral{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return optsArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = optsArray[indexPath.row]
        cell.textLabel.textColor = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 0, alpha: 1)
        cell.backgroundColor = UIColor.clearColor()
        if  indexPath.row == 1{
        cell.imageView.image = UIImage(named: "plus")
        }else   {
            cell.imageView.image = UIImage(named: "news")
        }
        return cell
    }
}
// MARK: - Table view delegate
extension MenuLateral{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == indexSelected{
            toggleSideMenuView()
            return
        }
        indexSelected = indexPath.row
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.row == 0{//NewsView
            var newsView = storyboard.instantiateViewControllerWithIdentifier("NewsView") as MasterViewController
            sideMenuController()?.setContentViewController(newsView)
        }else{
            var reportViewController = storyboard.instantiateViewControllerWithIdentifier("Report") as ReportViewController
            sideMenuController()?.setContentViewController(reportViewController)
        }
    }
}