//
//  NotiVincoNavigation.swift
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 12/11/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

import UIKit

class NotiVincoNavigation: ENSideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var menu = mainStoryboard.instantiateViewControllerWithIdentifier("SideMenu") as MenuLateral
        sideMenu = ENSideMenu(sourceView: self.view, menuTableViewController: menu, menuPosition:.Left)
        sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 200.0 // optional, default is 160
        view.bringSubviewToFront(navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
// MARK: - ENSideMenu Delegate

extension NotiVincoNavigation: ENSideMenuDelegate{
    func sideMenuWillOpen() {
        NSNotificationCenter.defaultCenter().postNotificationName("menuWillOpen", object: nil)        
    }
    
    func sideMenuWillClose() {
       NSNotificationCenter.defaultCenter().postNotificationName("menuWillClose", object: nil)
    }
}