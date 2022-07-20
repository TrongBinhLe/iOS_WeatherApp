//
//  WelcomeViewController.swift
//  Clima
//
//  Created by admin on 15/07/2022.
//  Copyright © 2022 AppSEHC. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet  private weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = K.appName
    }

}
