//
//  String+.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 10/01/24.
//

import SwiftUI
import Foundation

extension String {
     
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}

