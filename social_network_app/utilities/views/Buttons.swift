//
//  Buttons.swift
//  social_network_app
//
//  Created by admin on 7/6/22.
//

import Foundation
import UIKit

class PrimaryButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        //self.backgroundColor = UIColor(named: "dark-primary-color")
        self.backgroundColor = UIColor(named: "new-primary-color")
        self.tintColor = UIColor(named: "white-color")
    }
}

class SecondaryButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        //self.backgroundColor = UIColor(named: "secondary-color")
        self.backgroundColor = UIColor(named: "new-secondary-color")
        self.tintColor = UIColor(named: "white-color")
    }
}

class DangerButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(named: "red-color")
        self.tintColor = UIColor(named: "white-color")
    }
}
