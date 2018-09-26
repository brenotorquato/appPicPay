//
//  transaction.swift
//  PicPay
//
//  Created by Breno Torquato on 24/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

struct transaction:Decodable{
    let id: Int
    let timestamp: Int
    let value: Int
    let status: String
    let destination_user: destination_user
    let success: Bool
}
