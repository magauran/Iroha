//
//  IRTransaction+Signed.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import IrohaCommunication

extension IRTransaction {
    func signed(with account: Account) throws -> Self {
        return try signed(withSignatories: [account.signer], signatoryPublicKeys: [account.publicKey])
    }
}

