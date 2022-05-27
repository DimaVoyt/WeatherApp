//
//  CustomTableViewCell.swift
//  WeatherApp
//
//  Created by Дмитрий Войтович on 01.05.2022.
//

import UIKit
class CustomTableViewCell: UITableViewCell {
static let identifier = "CustomTableViewCell"
    
    
    private let myNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        setupNamelabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with text: String) {
        myNameLabel.text = text

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myNameLabel.text = nil
    }
    

    
    func setupNamelabel() {
        contentView.addSubview(myNameLabel)
        
        myNameLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        myNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:10).isActive = true
            myNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:-10).isActive = true
            myNameLabel.heightAnchor.constraint(equalToConstant:40).isActive = true
    }
}

