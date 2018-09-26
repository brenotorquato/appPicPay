//
//  exString.swift
//  PicPay
//
//  Created by Breno Torquato on 18/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//


extension String {
    
    func removeFormatacao() -> String {
        
        return self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: nil)
        
    }
    
}
