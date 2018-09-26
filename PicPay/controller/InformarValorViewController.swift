//
//  InformarValorViewController.swift
//  PicPay
//
//  Created by Breno Torquato on 18/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import CoreData
import UIKit


class InformarValorViewController: PicPayViewController, UITextFieldDelegate {

    //MARK: attributes
    var person: Person!
    
    @IBOutlet weak var txfValor: UITextField!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initTxfValor()
    }
    
    //MARK: initTxfValor
    private func initTxfValor(){
        txfValor.textAlignment = .center
        txfValor.delegate = self
        txfValor.keyboardType = .numberPad
        txfValor.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
    }

    //MARK: textFieldDidChange
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txfValor {
            textField.placeholder = ""
        }
    }
    
    //MARK: isFormularioValido
    private func isFormularioValido() -> Bool {
        if let _valor = txfValor.text {
            let valor:Double = Double(Util.removerFormatoMonetario(_valor)) ?? 0.0
            if valor == 0.0 {
                self.showToastNotification(message: "O valor de transferencia não pode ser R$ 0,00")
                return false
            }
        }
        return true
    }
    
    //MARK: enviarAction
    @IBAction func enviarAction(_ sender: Any) {
        if isFormularioValido() {
            // verificar no banco local se possui cartao cadastrado
            let listaCartoes = LocalDataBase(entityName: "Card").list()
            if listaCartoes.count != 0 {
                if listaCartoes.count == 1 {
                    // caso tenha cartao cadastrado, efetivar transferencia
                    efetivarTransferencia(card: listaCartoes[0])
                } else {
                    performSegue(withIdentifier: "toListarCartoes", sender: listaCartoes)
                }
            } else {
                // sem cartao cadastrado, realizar cadastro do cartao
                performSegue(withIdentifier: "toCadastrarCartao", sender: person)
            }
        } else {
            // emitir alert informando que formulario esta incompleto
            self.showToastNotification(message: "Necessário informar um valor.")
        }
    }
    
    //MARK: efetivarTransferencia
    private func efetivarTransferencia(card: NSManagedObject){
        if let strValor = txfValor.text {
            let strLimpo = Util.removerFormatoMonetario(strValor)
            let postParams:[String:AnyObject] = [
                "card_number":card.value(forKey: "card_number") as AnyObject,
                "cvv":card.value(forKey: "cvv") as AnyObject,
                "value":Double(strLimpo) as AnyObject,
                "expiry_date":card.value(forKey: "expiry_date") as AnyObject,
                "destination_user_id":person.id as AnyObject
            ]
            APIRest.transferindoValores(params: postParams){ sucesso, retorno in
                do {
                    let postReturn = try JSONDecoder().decode(Root.self, from: retorno)
                    if postReturn.transaction.success {
                        // back to root viewcontroller
                        self.navigationController?.popToRootViewController(animated: true)
                        self.showToastNotification(message: "Transferencia realizada com sucesso!!!")
                    }else {
                        let cardNumber:String = card.value(forKey: "card_number") as! String
                        if cardNumber != "1111111111111111" {
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
    
    //MARK: prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let strValor = txfValor.text {
            if segue.identifier == "toCadastrarCartao" {
                // necessario limpar valor formatado
                let strLimpo = Util.removerFormatoMonetario(strValor)
                let destino = segue.destination as! CadastrarCartaoViewController
                destino.person = sender as? Person
                destino.valorTransferir = Double(strLimpo)
            }
            if segue.identifier == "toListarCartoes" {
                // ListarCartoesViewController
                let destino = segue.destination as! ListarCartoesViewController
                destino.listaCartoes = sender as? [NSManagedObject]
                destino.person = self.person
                destino.valor = Double(Util.removerFormatoMonetario(strValor))
            }
        }
    }
    
    //MARK: textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let novoText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if novoText.length > 15 {
            return false
        }
        if textField == txfValor {
            if range.length == 1 {
                let indexInicial = txfValor.text!.startIndex
                let indexFinal = txfValor.text!.index(txfValor.text!.startIndex, offsetBy: (txfValor.text?.count)! - 1)
                textField.text = String(describing: txfValor.text?[indexInicial ..< indexFinal])
            } else {
                txfValor.text = "\(txfValor.text!)\(string)"
            }
            if let valorTextField = txfValor.text {
                let valorString = valorTextField.removeFormatacao()
                if let valorDouble = Double(valorString) {
                    let valor = valorDouble/100.0
                    txfValor.text = valor.formataValorMonetario()
                }
            }
            return false
        }
        return true
    }
}
