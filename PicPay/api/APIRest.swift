//
//  APIRest.swift
//  PicPay
//
//  Created by Breno Torquato on 16/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import Alamofire

class APIRest {
    
    typealias UsersCallback = (_ sucesso:Bool, _ retorno:Data) -> ()
    typealias RequestCallback = (_ sucesso:Bool, _ data: Data) -> ()
    
    //MARK: carregandoUsuarios
    static func carregandoUsuarios(params:Dictionary<String, AnyObject?>?, callback: @escaping UsersCallback){
        let getURL = "http://careers.picpay.com/tests/mobdev/users"
        executeRequest(method: .get, endPoint: getURL, params: params){ sucesso, data in
            callback(sucesso, data)
        }
    }
    
    //MARK: transferindoValores
    static func transferindoValores(params:Dictionary<String, AnyObject?>?, callback: @escaping UsersCallback){
        let postURL = "http://careers.picpay.com/tests/mobdev/transaction"
        executeRequest(method: .post, endPoint: postURL, params: params){ sucesso, data in
            callback(sucesso, data)
        }
    }
    
    //MARK: executeRequest
    private static func executeRequest(method: HTTPMethod,
                               endPoint:String,
                               params:Dictionary<String, AnyObject?>?,
                               callback: @escaping RequestCallback){
        
        guard let url = URL(string: endPoint) else { return }
        
        // preparando parametros
        var paramRequest:[String:Any]!
        if let _param = params {
            paramRequest = _param as [String : AnyObject]?
        }
        
        let headers:[String:String] = [
            "Content-Type": method == .get ? "application/x-www-form-urlencoded" : "application/json"
        ]
        
        Alamofire.request(url, method: method, parameters: paramRequest, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            guard let data = response.data else { return }
            DispatchQueue.main.async {
                callback(true, data)
            }
        }
        
    }
    
}
