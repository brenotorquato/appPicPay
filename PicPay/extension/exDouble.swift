//
//  exDouble.swift
//  PicPay
//
//  Created by Breno Torquato on 18/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import Foundation

extension Double {
    
    func formataValorMonetario() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencyCode = "R$"
        
        let valorFormatar = NSNumber(value: self as Double)
        if let valor = formatter.string(from: valorFormatar){
            return valor
        }
        return ""
    }
    
}
