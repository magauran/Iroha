//
//  IRCommand+Description.swift
//  Iroha
//
//  Created by Alexey Salangin on 13/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import IrohaCommunication

extension IRCommand {
    var customDescription: String {
        switch self {
        case let addAssetQuantity as IRAddAssetQuantity:
            return "+ \(addAssetQuantity.amount.value) \(addAssetQuantity.assetId.name)"
        case let transferAsset as IRTransferAsset:
            return "Transfer \(transferAsset.amount.value) \(transferAsset.assetId.name) " +
            "from  \(transferAsset.sourceAccountId.name) to \(transferAsset.destinationAccountId.name)"
        default: return ""
        }
    }
}
