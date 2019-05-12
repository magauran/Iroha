//
//  IrohaErrors.swift
//  Iroha
//
//  Created by Alexey Salangin on 11/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import IrohaCommunication

extension IRErrorResponseReason: Error {}

enum IrohaError: Error {
    case unexpectedResponse(response: String)
    case invalidTransaction
}
