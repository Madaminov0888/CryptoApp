//
//  UIAplication+.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 26/10/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) 
    }
}
