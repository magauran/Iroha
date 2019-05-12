//
//  Account.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import IrohaCommunication

struct Account {
    let publicKeyString: String
    let privateKeyString: String
    
    var publicKey: IRPublicKeyProtocol {
        let publicKeyData = publicKeyString.hexadecimal!
        return IREd25519PublicKey(rawData: publicKeyData)!
    }
    
    private var privateKey: IRPrivateKeyProtocol {
        let privateKeyData = privateKeyString.hexadecimal!
        return IREd25519PrivateKey(rawData: privateKeyData)!
    }
    
    var signer: IRSignatureCreatorProtocol {
        return IREd25519Sha512Signer(privateKey: privateKey)!
    }
}

extension Account {
    static var admin: Account {
        return Account(publicKeyString: Constants.adminPublicKey, privateKeyString: Constants.adminPrivateKey)
    }
}
