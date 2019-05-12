//
//  IrohaService.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import IrohaCommunication

class IrohaService {
    private let networkService: IRNetworkService = {
        let irohaAddress = try! IRAddressFactory.address(withIp: Constants.irohaIp, port: Constants.irohaPort)
        return IRNetworkService(address: irohaAddress)
    }()
    
    func execute(transaction: IRTransaction, then handler: @escaping (Error?) -> Void) {
        _ = networkService.execute(transaction)
            .onThen { [unowned self] result -> IRPromise? in
                guard
                    let transactionResult = result,
                    let transactionHash = transactionResult as? Data
                    else { return IRPromise(result: result) }
                return self.networkService.onTransactionStatus(.committed, withHash: transactionHash)
            }.onThen { result -> IRPromise? in
                if let status = result as? IRTransactionStatus, status == IRTransactionStatus.committed {
                    handler(nil)
                } else {
                    handler(IrohaError.invalidTransaction)
                }
                return nil
        }
    }
}
