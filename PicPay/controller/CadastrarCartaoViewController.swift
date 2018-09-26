//
//  CadastrarCartaoViewController.swift
//  PicPay
//
//  Created by Breno Torquato on 19/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import UIKit

class CadastrarCartaoViewController: PicPayViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    //MARK: attributes
    let pickerMesAno: MonthYearPickerView = MonthYearPickerView()
    
    var person:Person!
    var cartao:Cartao = Cartao()
    var valorTransferir:Double!
    
    @IBOutlet weak var txfNumeroCartao: UITextField!
    @IBOutlet weak var txfNomeCartao: UITextField!
    @IBOutlet weak var txfCvv: UITextField!
    @IBOutlet weak var txfValidade: UITextField!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializarInterfaceGrafica()
    }
    
    //MARK: closeKeyboard
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: inicializarInterfaceGrafica
    private func inicializarInterfaceGrafica() {
        // textfields
        inicializarTxfNumeroCartao()
        inicializarTxfCvv()
        inicializarTxfValidade()
        inicializarTxfNomeCartao()
        adicionarTapGesture()
    }
    
    //MARK: inicializarTxfNumeroCartao
    private func inicializarTxfNumeroCartao(){
        txfNumeroCartao.keyboardType = .numberPad
        txfNumeroCartao.delegate = self
    }
    
    //MARK: inicializarTxfCvv
    private func inicializarTxfCvv(){
        txfCvv.keyboardType = .numberPad
        txfCvv.delegate = self
    }
    
    //MARK: inicializarTxfCvv
    private func inicializarTxfValidade(){
        pickerMesAno.onDateSelected = {(mes: Int, ano: Int) in
            let validade = "\(mes < 10 ? "0\(mes)" : "\(mes)")/\(ano)"
            self.cartao.validade = validade
            self.txfValidade.text = validade
        }
        txfValidade.inputView = pickerMesAno
        txfValidade.delegate = self
    }
    
    //MARK: inicializarTxfNomeCartao
    private func inicializarTxfNomeCartao(){
        txfNomeCartao.delegate = self
    }
    
    //MARK: adicionarTapGesture
    private func adicionarTapGesture(){
        // esconde teclado tocando fora do textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: isFormularioValido
    private func isFormularioValido() -> Bool {
        
        guard let strNumeroCartao = txfNumeroCartao.text else { return false }
        guard let strNomeCartao = txfNomeCartao.text else { return false }
        guard let strCvv = txfCvv.text else { return false }
        
        if strNumeroCartao.count < 16 {
            return false
        } else {
            cartao.numero = strNumeroCartao
        }
        
        if strNomeCartao.isEmpty {
            return false
        } else {
            cartao.nome = strNomeCartao
        }
        
        if strCvv.isEmpty {
            return false
        } else {
            cartao.cvv = Int(strCvv)
        }
        
        return true
        
    }
    
    //MARK: cadastrarAction
    @IBAction func cadastrarAction(_ sender: Any) {
        
        if isFormularioValido() {
            
            // salvando cartao em base local
            let saveLocalCard:[String:Any] = [
                "card_number" : cartao.numero,
                "cvv" : cartao.cvv,
                "expiry_date" : cartao.validade
            ]
            LocalDataBase(entityName: "Card").save(saveLocalCard)
            
            // efetivando transferencia de valor
            let postParams:[String:AnyObject] = [
                "card_number":cartao.numero as AnyObject,
                "cvv":cartao.cvv as AnyObject,
                "value":valorTransferir as AnyObject,
                "expiry_date":cartao.validade as AnyObject,
                "destination_user_id":person.id as AnyObject
            ]
            
            APIRest.transferindoValores(params: postParams){ sucesso, retorno in
                
                do {
                    let postReturn = try JSONDecoder().decode(Root.self, from: retorno)
                    if postReturn.transaction.success {
                        // back to root viewcontroller
                        self.navigationController?.popToRootViewController(animated: true)
                        self.showToastNotification(message: "Transferencia realizada com sucesso!!!")
                    } else {
                        if self.cartao.numero != "1111111111111111" {
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
    
    //MARK: textField - limitar os campos do formulario
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength:Int!
        
        if textField == txfNumeroCartao {
            maxLength = 16
        }
        
        if textField == txfNomeCartao {
            maxLength = 100
        }
        
        if textField == txfCvv {
            maxLength = 3
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
    }
    
}
