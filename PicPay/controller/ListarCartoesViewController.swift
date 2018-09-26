//
//  ListarCartoesViewController.swift
//  PicPay
//
//  Created by Breno Torquato on 25/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import CoreData
import UIKit

class ListarCartoesViewController: PicPayViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: attributes
    var valor:Double!
    var person:Person!
    var listaCartoes:[NSManagedObject]!
    
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarTableView()
    }
    
    //MARK: configurarTableView
    private func configurarTableView(){
        // removendo espaco em brando do footer do tableview
        self.tableview.tableFooterView = UIView()
        tableview.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    //MARK: transferir
    private func transferir(postParams:[String:AnyObject]){
        APIRest.transferindoValores(params: postParams){ sucesso, retorno in
            do {
                let postReturn = try JSONDecoder().decode(Root.self, from: retorno)
                if postReturn.transaction.success {
                    // back to root viewcontroller
                    self.navigationController?.popToRootViewController(animated: true)
                    self.showToastNotification(message: "Transferencia realizada com sucesso!!!")
                } else {
                    let cardNumer:String = postParams["card_number"] as! String
                    if cardNumer != "1111111111111111" {
                        self.showToastNotification(message: "Este cartão não está autorizado a realizar transferencia.")
                    } else {
                        self.showToastNotification(message: "Houve um erro ao realizar a transferencia.")
                    }
                }
            } catch let error {
                self.showToastNotification(message: "Houve um erro ao realizar a transferencia. \(error)")
            }
        }
    }

}

extension ListarCartoesViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCartoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listaCartoes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardTableViewCell
        cell.lblCardNumber.text = item.value(forKey: "card_number") as? String
        cell.lblExpiryDate.text = item.value(forKey: "expiry_date") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listaCartoes[indexPath.row]
        let postParams:[String:AnyObject] = [
            "card_number":item.value(forKey: "card_number") as AnyObject,
            "cvv":item.value(forKey: "cvv") as AnyObject,
            "value":valor as AnyObject,
            "expiry_date":item.value(forKey: "expiry_date") as AnyObject,
            "destination_user_id":person.id as AnyObject
        ]
        self.transferir(postParams: postParams)
    }
    
}
