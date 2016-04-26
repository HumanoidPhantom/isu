//
//  TabBarController.swift
//  isu
//
//  Created by Phantom on 01/08/15.
//  Copyright (c) 2015 Phantom. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated:true)
        let myBackButton:UIButton = UIButton.init(type: UIButtonType.Custom)
        
        myBackButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        let myImage = UIImage(named: "android-arrow-back.png")
        myBackButton.setImage(myImage, forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = myCustomBackButtonItem
    }
    
    func popToRoot(sender:UIBarButtonItem){
        let deleteData = DataRequest()
        deleteData.deleteAllFromCoreData()

        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
