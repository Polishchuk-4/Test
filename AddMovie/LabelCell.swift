//
//  LabelCell.swift
//  AddMovie
//
//  Created by Denis Polishchuk on 31.08.2022.
//

import UIKit

class LabelCell: UITableViewCell {
    var label: UILabel!
    static let heightLabelCell: CGFloat = 70
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel() {
        self.label = UILabel()
        self.label.frame.size.width = UIScreen.main.bounds.width * 0.93
        self.label.frame.size.height = LabelCell.heightLabelCell
        self.label.textAlignment = .left
        self.label.font = UIFont.systemFont(ofSize: 28)
        self.contentView.addSubview(label)
    }
}
