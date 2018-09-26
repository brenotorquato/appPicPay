//
//  Util.swift
//  PicPay
//
//  Created by Breno Torquato on 25/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

class Util {
    
    static func removerFormatoMonetario(_ texto: String) -> String {
        
        return texto.replacingOccurrences(of: "R$", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespaces)
        
        
    }
    
}
