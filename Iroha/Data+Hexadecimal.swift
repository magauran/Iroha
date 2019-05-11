//
//  Data+Hexadecimal
//  Iroha
//
//  Created by Alexey Salangin on 11/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import Foundation

extension Data {
    var hexadecimal: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}
