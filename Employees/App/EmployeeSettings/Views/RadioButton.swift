//
//  RadioButton.swift
//  Employees
//
//  Created by Александра Широкова on 23.09.2022.
//

import UIKit

final class RadioButton: UIButton {
    
    private let heightImage: CGFloat = 20
    private let checkedImage = UIImage(named: "RadioChecked")
    private let unCheckedImage = UIImage(named: "RadioUnchecked")
    
    var isChecked: Bool = false {
        didSet {
            setStatusView()
        }
    }
    
    required init(title: String) {
        super.init(frame: .zero)
        configureButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RadioButton {
    func setStatusView() {
        if isChecked {
            setImage(checkedImage, for: .normal)
        } else {
            setImage(unCheckedImage, for: .normal)
        }
    }
    
    func configureButton(title: String) {
        let attributedFontNormal = UIFont(name: "Inter-Medium", size: 16) ?? .systemFont(ofSize: 16)
        let attributedTextNormal = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.font: attributedFontNormal,
                         NSAttributedString.Key.foregroundColor: UIColor.blackAmber]
        )
        setAttributedTitle(attributedTextNormal, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 14)
        
        setStatusView()
        
        guard let currentImageView = imageView else { return }
        NSLayoutConstraint.activate([
            currentImageView.heightAnchor.constraint(equalToConstant: heightImage),
            currentImageView.widthAnchor.constraint(equalToConstant: heightImage),
        ])
    }
}
