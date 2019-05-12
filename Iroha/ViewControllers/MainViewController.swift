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
    
    private var timer: Timer?
    private let irohaService = IrohaService()
    private var query: IRQueryRequest {
        let userAccountId: IRAccountId = {
            return try! IRAccountIdFactory.account(withIdentifier: LoginService.currentAccount!)
        }()
        
        return try! IRQueryBuilder(creatorAccountId: userAccountId)
            .getAccountAssets(userAccountId)
            .build()
            .signed(with: Account.admin)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [unowned self] _ in
            self.reloadData()
        }
    }
    
    private func reloadData() {
        irohaService.execute(query: query, responseType: IRAccountAssetsResponse.self) { result in
            switch result {
            case .success(let response):
                response.accountAssets.forEach { asset in
                    if asset.assetId.name == "pokeball" {
                        self.pokeballsLabel.text = "\(asset.balance.value) pokeballs"
                    }
                    if asset.assetId.name == "pokecoin" {
                        self.coinsLabel.text = "\(asset.balance.value) pokecoins"
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
