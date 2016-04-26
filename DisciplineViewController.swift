//
//  SelectedDisciplineViewController.swift
//  isu
//
//  Created by Phantom on 03/08/15.
//  Copyright (c) 2015 Phantom. All rights reserved.
//

import UIKit

class DisciplineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let backItem = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        navigationItem.backBarButtonItem = backItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
