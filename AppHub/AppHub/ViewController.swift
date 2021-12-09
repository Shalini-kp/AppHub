//
//  ViewController.swift
//  AppHub
//
//  Created by Shalini K P on 08/12/2021.
//

import UIKit
import Login

class ViewController: UIViewController {

    @IBAction func buttonTapped(_ sender: Any) {
        let vc = Login.LoginViewController()
        self.present(vc.controller(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

