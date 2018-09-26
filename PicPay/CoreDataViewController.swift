////
////  CoreDataViewController.swift
////  PicPay
////
////  Created by Breno Torquato on 16/09/2018.
////  Copyright © 2018 Breno Torquato. All rights reserved.
////
//
//import UIKit
//
//class CoreDataViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // nova estrutura
////        let paramIncluirCartao:[String:Any] = [
////            "card_number" : "2222222222222222",
////            "cvv" : 222,
////            "expiry_date" : "02/25"
////        ]
////        LocalDataBase(entityName: "Card").save(paramIncluirCartao)
//        
////        LocalDataBase(entityName: "Card").delete(["card_number":"2222222222222222"])
//        
//        let listaCartoes = LocalDataBase(entityName: "Card").list()
//        for cartao in listaCartoes {
//            print(cartao.value(forKey: "card_number") as! String)
//        }
//        
////        if let valueGet = LocalDataBase(entityName: "Card").find(["card_number" : "2222222222222222"]) {
////            print("### VALOR RESGATADO: \(valueGet.value(forKey: "card_number"))")
////        }
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//}
//
//
