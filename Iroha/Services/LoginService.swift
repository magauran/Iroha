//
//  LoginService.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import IrohaCommunication

class LoginService {
    static var currentAccount: Account? = nil
    
    private let networkService: IRNetworkService = {
        let irohaAddress = try! IRAddressFactory.address(withIp: Constants.irohaIp, port: Constants.irohaPort)
        return IRNetworkService(address: irohaAddress)
    }()
    
    func login(accountId: String,
               publicKeyString: String,
               privateKeyString: String,
               then handler: @escaping (Error?) -> Void){
        let userAccountId: IRAccountId = {
            return try! IRAccountIdFactory.account(withIdentifier: accountId)
        }()
        
        do {
            let queryRequest = try IRQueryBuilder(creatorAccountId: userAccountId)
                .getAccount(userAccountId)
                .build()
                .signed(with: Account.admin) // TODO: replace With a real user account
            _ = networkService.execute(queryRequest)
                .onThen { result -> IRPromise? in
                    LoginService.currentAccount = Account(accountId: accountId,
                                                          publicKeyString: publicKeyString,
                                                          privateKeyString: privateKeyString)
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
