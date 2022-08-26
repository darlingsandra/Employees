//
//  CustomSegmentedControl.swift
//  Employees
//
//  Created by Александра Широкова on 26.08.2022.
//

import UIKit

final class CustomSegmentedControl: UIScrollView {

    var tabs: [CustomSegmentedButton] = []
    
    required init(items: [String]) {
        super.init(frame: .zero)
        configure(items: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(_ target: Any?, action: Selector) {
        tabs.forEach { $0.addTarget(target, action: action, for: .touchUpInside) }
    }
}

private extension CustomSegmentedControl {
    
    func configure(items: [String]) {
        tabs = items.map { CustomSegmentedButton(title: $0) }
        tabs.first?.isSelected = true
        
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .customPurple
                           
        let buttonStackView = UIStackView(arrangedSubviews: tabs)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [buttonStackView, underlineView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        addSubview(stackView)
                
        NSLayoutConstraint.activate([
            underlineView.heightAnchor.constraint(equalToConstant: 1),

            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }    
}
