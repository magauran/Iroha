//
//  TransactionsTableViewController.swift
//  Iroha
//
//  Created by Alexey Salangin on 13/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit
import IrohaCommunication

class TransactionsTableViewController: UITableViewController {
    private let irohaService = IrohaService()
    
    private var query: IRQueryRequest {
        let userAccountId: IRAccountId = {
            return try! IRAccountIdFactory.account(withIdentifier: LoginService.currentAccount!)
        }()
        
        let pagination = try! IRPaginationFactory.pagination(100, firstItemHash: nil)
        
        return try! IRQueryBuilder(creatorAccountId: userAccountId)
            .getAccountTransactions(userAccountId, pagination: pagination)
            .build()
            .signed(with: Account.admin)
    }
    
    private var transactions = [IRTransaction]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        let transaction = transactions[indexPath.row]
        let transactionHash = (try? transaction.transactionHash())?.hexadecimal ?? ""
        cell.textLabel?.text = transaction.commands[0].customDescription
        cell.detailTextLabel?.text = transactionHash
        return cell
    }
    
    private func reloadData() {
        irohaService.execute(query: query, responseType: IRTransactionsPageResponse.self) { [unowned self] result in
            switch result {
            case .success(let response):
                self.transactions = response.transactions
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

