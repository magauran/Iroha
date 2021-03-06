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
    @IBOutlet private weak var tableView: UITableView!
    
    private var timer: Timer?
    private let irohaService = IrohaService()
    private var query: IRQueryRequest {
        let userAccountId: IRAccountId = {
            return try! IRAccountIdFactory.account(withIdentifier: LoginService.currentAccount!.accountId)
        }()
        
        return try! IRQueryBuilder(creatorAccountId: userAccountId)
            .getAccountAssets(userAccountId)
            .build()
            .signed(with: LoginService.currentAccount!)
    }
    private var assets = [IRAccountAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = LoginService.currentAccount?.accountId
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
        irohaService.execute(query: query, responseType: IRAccountAssetsResponse.self)
        { [unowned self] result in
            switch result {
            case .success(let response):
                self.assets = response.accountAssets
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetTableViewCell", for: indexPath) as! AssetTableViewCell
        let asset = assets[indexPath.row]
        cell.nameLabel?.text = asset.assetId.name
        cell.amountLabel?.text = asset.balance.value
        cell.iconImageView?.image = {
            switch asset.assetId.name {
            case "pokeball": return UIImage(named: "pokeball")
            case "pokecoin": return UIImage(named: "pokecoin")
            case "pokemon": return UIImage(named: "pikachu-2")
            case "badge": return UIImage(named: "star-1")
            default: return nil
            }
        }()
        return cell
    }
}
