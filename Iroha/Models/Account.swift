//
//  Account.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import IrohaCommunication

struct Account {
    let accountId: String
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
        return Account(accountId: Constants.adminAccountId,
                       publicKeyString: Constants.adminPublicKey,
                       privateKeyString: Constants.adminPrivateKey)
    }
    
    static var trainer: Account {
        return Account(accountId: Constants.trainerAccountId,
                       publicKeyString: Constants.trainerPublicKey,
                       privateKeyString: Constants.trainerPrivateKey)
    }
    
    static var leader: Account {
        return Account(accountId: Constants.leaderAccountId,
                       publicKeyString: Constants.leaderPublicKey,
                       privateKeyString: Constants.leaderPrivateKey)
    }
    
    static var pokestop: Account {
        return Account(accountId: Constants.pokestopAccountId,
                       publicKeyString: Constants.pokestopPublicKey,
                       privateKeyString: Constants.pokestopPrivateKey)
    }
    
    static var nature: Account {
        return Account(accountId: Constants.natureAccountId,
                       publicKeyString: Constants.naturePublicKey,
                       privateKeyString: Constants.naturePrivateKey)
    }
}
