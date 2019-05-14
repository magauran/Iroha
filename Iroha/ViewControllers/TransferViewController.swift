//
//  TransferViewController.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit
import IrohaCommunication

class TransferViewController: UIViewController {
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            self.sendButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet private weak var assetTextField: UITextField!
    @IBOutlet private weak var destinationTextField: UITextField!
    @IBOutlet private weak var amountTextField: UITextField!
    
    private let irohaService = IrohaService()
    
    @IBAction private func send() {
        defer {
            view.endEditing(true)
        }
        // TODO: validate inputs
        
        guard
            let userAccountId = try? IRAccountIdFactory.account(withIdentifier: LoginService.currentAccount!.accountId),
            let destinationAccountId = try? IRAccountIdFactory.account(withIdentifier: destinationTextField.text ?? ""),
            let assetId = try? IRAssetIdFactory.asset(withIdentifier: assetTextField.text ?? ""),
            let amount = try? IRAmountFactory.amount(from: amountTextField.text ?? "0")
            else {
            print("Incorrect user input")
            return
        }
            
        let transaction = try! IRTransactionBuilder(creatorAccountId: userAccountId)
            .transferAsset(userAccountId,
                           destinationAccount: destinationAccountId,
                           assetId: assetId,
                           description: "Description",
                           amount: amount)
            .build()
            .signed(with: LoginService.currentAccount!)
        irohaService.execute(transaction: transaction) { error in
            if let error = error {
                print(error)
                return
            }
            print("Success")
        }
    }
}
