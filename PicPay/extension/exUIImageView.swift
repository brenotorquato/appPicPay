//
//  exUIImageView.swift
//  PicPay
//
//  Created by Breno Torquato on 18/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
            }.resume()
        
    }
    
}
