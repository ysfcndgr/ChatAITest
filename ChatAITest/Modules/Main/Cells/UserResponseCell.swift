//
//  UserResponseCell.swift
//  Capstone Project Cem
//
//  Created by Can on 9.06.2024.
//

import UIKit

final class UserResponseCell: UITableViewCell {
    
    @IBOutlet private weak var textView: UITextView!
    
    func configure(with text: String) {
        textView.text = text
        textView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    
    
}
