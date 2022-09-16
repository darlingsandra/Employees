//
//  EmployeeNoFound.swift
//  Employees
//
//  Created by Александра Широкова on 12.09.2022.
//

import UIKit

final class EmployeeNoFound: UIView {
    
    private let sizeImage: CGFloat = 56
    
    required init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmployeeNoFound {
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView(image:  UIImage(named: "Find"))
        image.translatesAutoresizingMaskIntoConstraints = false
       
        let noFoundLabel = UILabel()
        noFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        noFoundLabel.font = UIFont(name: "Inter-SemiBold", size: 17) ?? .systemFont(ofSize: 17)
        noFoundLabel.textColor = .blackAmber
        noFoundLabel.text = "Мы никого не нашли"
        
        let tryLabel = UILabel()
        tryLabel.translatesAutoresizingMaskIntoConstraints = false
        tryLabel.font = UIFont(name: "Inter-Regular", size: 16) ?? .systemFont(ofSize: 16)
        tryLabel.textColor = .pearlLightGray
        tryLabel.text = "Попробуй скорректировать запрос"
        
        self.addSubview(image)
        self.addSubview(noFoundLabel)
        self.addSubview(tryLabel)
        
        NSLayoutConstraint.activate(
            [
                noFoundLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                noFoundLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                
                tryLabel.topAnchor.constraint(equalTo: noFoundLabel.bottomAnchor, constant: 12),
                tryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                
                image.bottomAnchor.constraint(equalTo: noFoundLabel.topAnchor, constant: -8),
                image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                image.heightAnchor.constraint(equalToConstant: sizeImage),
                image.widthAnchor.constraint(equalTo: image.heightAnchor),
            ]
        )
    }
}
