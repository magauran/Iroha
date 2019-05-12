//
//  IRQueryRequest+Signed.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import IrohaCommunication

extension IRQueryRequest {
    func signed(with account: Account) throws -> Self {
        return try signed(withSignatory: account.signer, signatoryPublicKey: account.publicKey)
    }
}
