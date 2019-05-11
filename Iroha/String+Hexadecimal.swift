//
//  String+Hexadecimal.swift
//  Iroha
//
//  Created by Alexey Salangin on 11/05/2019.
//  Copyright © 2019 Alexey Salangin. All rights reserved.
//

import Foundation

extension String {
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        guard !data.isEmpty else { return nil }
        return data
    }
}
