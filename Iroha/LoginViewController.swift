//
//  LoginViewController.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var accountIdTextField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            self.loginButton.layer.cornerRadius = 10
        }
    }
    
    private let loginService = LoginService()
    
    @IBAction private func login() {
        let id = accountIdTextField.text
        loginService.login(accountId: id!) { [unowned self] error in
            if let error = error {
                self.showError(error)
                return
            }
            
            self.showMainScreen()
        }
    }
    
    private func showError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    func showMainScreen() {
        performSegue(withIdentifier: "MainViewController", sender: nil)
    }
}
