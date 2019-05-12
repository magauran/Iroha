//
//  LoginService.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import IrohaCommunication

class LoginService {
    typealias Account = String
    static var currentAccount: Account? = nil
    
    private let networkService: IRNetworkService = {
        let irohaAddress = try! IRAddressFactory.address(withIp: Constants.irohaIp, port: Constants.irohaPort)
        return IRNetworkService(address: irohaAddress)
    }()
    
    func login(accountId: String, then handler: @escaping (Error?) -> Void) {
        let userAccountId: IRAccountId = {
            return try! IRAccountIdFactory.account(withIdentifier: accountId)
        }()
        
        do {
            let queryRequest = try IRQueryBuilder(creatorAccountId: userAccountId)
                .getAccount(userAccountId)
                .build()
            _ = networkService.execute(queryRequest)
                .onThen { result -> IRPromise? in
                    LoginService.currentAccount = accountId
                    handler(nil)
                    return nil
                }.onError { error -> IRPromise? in
                    handler(error)
                    return nil
            }
        } catch {
            return handler(error)
        }
    }
}
