//
//  CircleButton.swift
//  ascii
//
//  Created by Alex Wayne on 1/26/23.
//

import Foundation
import UIKit

class CircleButton : UIButton {
    
    init(_ symbol: String, diameter: CGFloat = 64, symbolSize: CGFloat = 18, weight: UIImage.SymbolWeight = .heavy) {
        super.init(frame: .zero)
        
        let config = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: weight)
        self.setImage(UIImage(systemName: symbol, withConfiguration: config), for: .normal)        
        self.backgroundColor = UIColor(named: "accent")
        self.layer.cornerRadius = diameter / 2
        self.translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: diameter).isActive = true
        heightAnchor.constraint(equalToConstant: diameter).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
