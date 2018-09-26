//
//  PicPayViewController.swift
//  PicPay
//
//  Created by Breno Torquato on 18/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import UIKit
import Toaster

class PicPayViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configurandoTela()
        
    }

    private func configurandoTela() {
        
        // definindo titulo
        self.title = "PicPay"
        
    }
    
    func showToastNotification(message: String){
        let toast = Toast(text: message)
        toast.show()
    }
    
}
