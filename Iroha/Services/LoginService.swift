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

    private let irohaService = IrohaService()
    
    func login(accountId: String,
               publicKeyString: String,
               privateKeyString: String,
               then handler: @escaping (Error?) -> Void){
        let userAccountId = try! IRAccountIdFactory.account(withIdentifier: accountId)
        let account = Account(accountId: accountId,
                              publicKeyString: publicKeyString,
                              privateKeyString: privateKeyString)
        
        do {
            let queryRequest = try IRQueryBuilder(creatorAccountId: userAccountId)
                .getAccount(userAccountId)
                .build()
                .signed(with: account)
            
            irohaService.execute(query: queryRequest, responseType: IRAccountResponse.self) { result in
                switch result {
                case .success:
                    LoginService.currentAccount = account
                    handler(nil)
                case .failure(let error):
                    handler(error)
                }
            }
            
        } catch {
            return handler(error)
        }
    }
}
