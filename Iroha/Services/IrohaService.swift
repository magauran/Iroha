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
                if let status = result as? UInt, status == IRTransactionStatus.committed.rawValue {
                    handler(nil)
                } else {
                    handler(IrohaError.invalidTransaction)
                }
                return nil
        }
    }
    
    func execute<ResponseType>(
        query: IRQueryRequest,
        responseType: ResponseType.Type,
        then handler: @escaping (Result<ResponseType, IrohaError>) -> Void
        ) {
        _ = networkService.execute(query)
            .onThen { result -> IRPromise? in
                guard
                    let result = result,
                    let accountAssetsResponse = result as? ResponseType
                    else {
                        handler(.failure(IrohaError.invalidQueryRequest))
                        return nil
                }
                handler(Result.success(accountAssetsResponse))
                return nil
            }
    }
}
