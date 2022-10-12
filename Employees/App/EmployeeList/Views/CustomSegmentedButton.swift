//
//  SegmentedButton.swift
//  Employees
//
//  Created by Александра Широкова on 26.08.2022.
//

import UIKit

final class CustomSegmentedButton: UIButton {
    
    var underlineView: UIView?
    var isUnderlined: Bool = false {
        didSet {
            if oldValue != isUnderlined {
                if isUnderlined == false && underlineView != nil {
                    underlineView?.removeFromSuperview()
                } else {
                    underlineView = createUnderlineView()
                    underlineView!.isHidden = !isSelected
                    insertSubview(underlineView!, at: subviews.count)
                    configureUnderlineConstraints()
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            underlineView?.isHidden = !isSelected
        }
    }
    
    private let paddingSide = 12.0
    
    required init(title: String) {
        super.init(frame: .zero)
        configureButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomSegmentedButton {
    
    func createUnderlineView() -> UIView {
        let underline = UIView()
        underline.backgroundColor = .blue
        return underline
    }
    
    func configureButton(title: String) {
        let attributedFontNormal = UIFont(name: "Inter-Medium", size: 15) ?? .systemFont(ofSize: 15)
        let attributedTextNormal = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.font: attributedFontNormal,
                         NSAttributedString.Key.foregroundColor: UIColor.pearlLightGray]
        )
        
        let attributedFontSelected = UIFont(name: "Inter-Bold", size: 15) ?? .systemFont(ofSize: 15)
        let attributedTextSelected = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.font: attributedFontSelected,
                         NSAttributedString.Key.foregroundColor: UIColor.blackAmber]
        )
         
        setAttributedTitle(attributedTextNormal, for: .normal)
        setAttributedTitle(attributedTextSelected, for: .selected)
        
        translatesAutoresizingMaskIntoConstraints = false
        titleEdgeInsets = UIEdgeInsets(top: 8, left: paddingSide, bottom: 8, right: paddingSide)
        
        isUnderlined = true
    
        configureButtonConstraints()
    }
        
    func configureButtonConstraints() {
        guard let labelWidth = titleLabel?.frame.width else { return }
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: labelWidth + 10 + paddingSide * 2).isActive = true
    }
    
    func configureUnderlineConstraints() {
        guard let underline = underlineView else { return }
        underline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underline.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            underline.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
}
