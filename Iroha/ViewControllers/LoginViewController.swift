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
    @IBOutlet private weak var publicKeyTextField: UITextField!
    @IBOutlet private weak var privateKeyTextField: UITextField!
    
    
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            self.loginButton.layer.cornerRadius = 10
        }
    }
    
    private let loginService = LoginService()
    
    @IBAction private func login() {
        guard let id = accountIdTextField.text,
            let publicKeyString = publicKeyTextField.text,
            let privateKeyString = privateKeyTextField.text
            else { return }
        loginService.login(accountId: id,
                           publicKeyString: publicKeyString,
                           privateKeyString: privateKeyString) { [unowned self] error in
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == accountIdTextField, let text = textField.text {
            switch text {
            case Account.admin.accountId:
                publicKeyTextField.text = Account.admin.publicKeyString
                privateKeyTextField.text = Account.admin.privateKeyString
            case Account.trainer.accountId:
                publicKeyTextField.text = Account.trainer.publicKeyString
                privateKeyTextField.text = Account.trainer.privateKeyString
            default:
                return
            }
        }
    }
}
