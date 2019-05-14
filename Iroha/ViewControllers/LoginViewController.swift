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
    
    @IBOutlet private weak var centerYConstraint: NSLayoutConstraint!
    private let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
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
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard
            let keyboardSize = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        centerYConstraint.constant = -(view.frame.height / 2 - keyboardSize.height) / 2 - view.safeAreaInsets.bottom
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide(notification: Notification){
        centerYConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
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
            case Account.leader.accountId:
                publicKeyTextField.text = Account.leader.publicKeyString
                privateKeyTextField.text = Account.leader.privateKeyString
            case Account.pokestop.accountId:
                publicKeyTextField.text = Account.pokestop.publicKeyString
                privateKeyTextField.text = Account.pokestop.privateKeyString
            case Account.nature.accountId:
                publicKeyTextField.text = Account.nature.publicKeyString
                privateKeyTextField.text = Account.nature.privateKeyString
            default:
                return
            }
        }
    }
}
