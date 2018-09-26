//
//  ListarPessoasViewController.swift
//  PicPay
//
//  Created by Breno Torquato on 18/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import UIKit

class ListarPessoasViewController: PicPayViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: attributes
    var listaPessoas:[Person]!
    var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarTableView()
        listarPessoas()
    }
    
    //MARK: configurarTableView
    private func configurarTableView() {
        // removendo espaco em brando do footer do tableview
        self.tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "PersonTableViewCellCell", bundle: nil), forCellReuseIdentifier: "personCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        tableView.backgroundView = self.activityIndicatorView
    }
    
    //MARK: listarPessoas
    private func listarPessoas() {
        activityIndicatorView.startAnimating()
        APIRest.carregandoUsuarios(params: [:]){ sucesso, retorno in
            self.activityIndicatorView.stopAnimating()
            do {
                let usersData = try JSONDecoder().decode([Person].self, from: retorno)
                DispatchQueue.main.async {
                    self.listaPessoas = usersData
                    self.tableView.reloadData()
                }
            } catch let error {
                self.showToastNotification(message: "Houve um erro ao realizar a transferencia. \(error)")
            }
        }
    }
    
    //MARK: prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInformarValor" {
            let destino:InformarValorViewController = segue.destination as! InformarValorViewController
            destino.person = sender as? Person
        }
    }
    
}

extension ListarPessoasViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPessoas != nil ? listaPessoas.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCellCell
        let person = listaPessoas[indexPath.row]
        
        cell.lblUserName.text = person.username
        cell.lblName.text = person.name
        cell.imgUser.loadImageUsingUrlString(urlString: person.img)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toInformarValor", sender: listaPessoas[indexPath.row])
    }
    
}
