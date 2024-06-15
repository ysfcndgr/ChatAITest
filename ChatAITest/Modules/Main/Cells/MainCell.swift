//
//  MainCell.swift
//  Capstone Project Cem
//
//  Created by Can on 9.06.2024.
//

import UIKit

final class MainCell: UITableViewCell {
    
    @IBOutlet private weak var textView: UITextView!
    
    func configure(with text: String){
        textView.text = text
        textView.layer.cornerRadius = 8
        layer.cornerRadius = 8
    }
}
