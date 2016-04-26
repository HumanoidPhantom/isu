//
//  MainViewController.swift
//  isu
//
//  Created by Phantom on 20/07/15.
//  Copyright (c) 2015 Phantom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var branchLabel: UILabel!
    
    @IBOutlet weak var facultyLabel: UILabel!
    
    @IBOutlet weak var proffesionLabel: UILabel!
    
    override func viewDidLoad() {
        let dataRequest = DataRequest()
        let userData = dataRequest.fetchUserData()
        
        let name = userData["name"]
        let surname = userData["surname"]
        let patronymic = userData["patronymic"]
    
        self.nameLabel.text = "\(surname!.capitalizedString) \(name!.capitalizedString) \(patronymic!.capitalizedString)"
        self.branchLabel.text = userData["fillial"]
        self.facultyLabel.text = userData["faculty"]
        self.proffesionLabel.text = userData["profession"]
    }
}
