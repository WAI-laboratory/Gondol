//
//  String+Extension.swift
//  Gondol
//
//  Created by 이용준 on 2021/11/12.
//

import Foundation

extension String {
     var localized: String { return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")}
}
