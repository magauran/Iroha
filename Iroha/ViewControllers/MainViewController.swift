//
//  MainViewController.swift
//  Iroha
//
//  Created by Alexey Salangin on 12/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import UIKit
import IrohaCommunication

class MainViewController: UIViewController {
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var coinsLabel: UILabel!
    @IBOutlet private weak var pokeballsLabel: UILabel!
    
    private let networkService: IRNetworkService = {
        let irohaAddress = try! IRAddressFactory.address(withIp: Constants.irohaIp, port: Constants.irohaPort)
        return IRNetworkService(address: irohaAddress)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userAccountId: IRAccountId = {
            return try! IRAccountIdFactory.account(withIdentifier: LoginService.currentAccount!)
        }()
        
        let query = try! IRQueryBuilder(creatorAccountId: userAccountId)
            .getAccountAssets(userAccountId)
            .build()
            .signed(with: Account.admin)
     
        _ = networkService.execute(query)
            .onThen { [unowned self] result -> IRPromise? in
                guard let result = result else { return nil }
                guard let accountAssetsResponse = result as? IRAccountAssetsResponse else { return nil }
                accountAssetsResponse.accountAssets.forEach { asset in
                    if asset.assetId.name == "pokeball" {
                        self.pokeballsLabel.text = "\(asset.balance.value) pokeballs"
                    }
                    if asset.assetId.name == "pokecoin" {
                        self.coinsLabel.text = "\(asset.balance.value) pokecoins"
                    }
                }
                
                return nil
            }.onError { error -> IRPromise? in
                
                return nil
        }
    }
}
