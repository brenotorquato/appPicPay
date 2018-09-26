//
//  Cartao.swift
//  PicPay
//
//  Created by Breno Torquato on 25/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

struct Cartao {
    
    var numero:String!
    var nome:String!
    var cvv:Int!
    var validade:String!
    
    func toArray() ->[String:Any] {
        return ["card_number" : numero, "name": nome, "cvv": cvv, "expiry_date":validade]
    }
    
}
