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
    @IBOutlet private weak var assetTextField: UITextField!
    @IBOutlet private weak var destinationTextField: UITextField!
    @IBOutlet private weak var amountTextField: UITextField!
    
    private let irohaService = IrohaService()
    
    @IBAction private func send() {
        // TODO: validate inputs
        
        let userAccountId: IRAccountId = {
            return try! IRAccountIdFactory.account(withIdentifier: LoginService.currentAccount!.accountId)
        }()
        
        let destinationAccountId: IRAccountId = {
            return try! IRAccountIdFactory.account(withIdentifier: destinationTextField.text ?? "")
        }()
        
        let assetId: IRAssetId = {
            return try! IRAssetIdFactory.asset(withIdentifier: assetTextField.text ?? "")
        }()
        
        let amount: IRAmount = {
            return try! IRAmountFactory.amount(from: amountTextField.text ?? "0")
        }()
            
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
