//
//  FormTextField.swift
//  Tromit
//
//  Created by Stacey Smith on 12/2/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

 @IBDesignable
class FormTextField: UITextField {

  @IBInspectable  var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var textFieldColor: UIColor? {
        didSet {
            textFieldColor = textColor
        }
    }
    

}
