//
//  UIViewController+Ext.swift
//  MeditationHelper
//
//  Created by Dinh Vu Nam on 7/25/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func findHairlineImageViewUnder(view: UIView) -> UIImageView?
    {
        if view .isKind(of: UIImageView.self) && view.bounds.size.height <= 1
        {
            return view as? UIImageView
        }
        
        for subview in view.subviews
        {
            let imageView = findHairlineImageViewUnder(view: subview)
            return imageView
        }
        
        return nil
    }
}
