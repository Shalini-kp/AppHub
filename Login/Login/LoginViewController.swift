//
//  LoginViewController.swift
//  Login
//
//  Created by Shalini K P on 08/12/2021.
//

import UIKit

public class LoginViewController: UIViewController {
    
    public func controller() -> LoginViewController {
        let storyboard = UIStoryboard.init(name: "Login", bundle: Bundle(for: type(of: self)))
         let vc = storyboard.instantiateViewController(identifier: "LoginViewControllerID") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
         return vc
     }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
