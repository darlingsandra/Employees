//
//  EmployeeInfoLabel.swift
//  Employees
//
//  Created by Александра Широкова on 05.08.2022.
//

import UIKit

final class EmployeeInfoLabel: UILabel {
    
    enum Style {
        case title
        case subTitle
        case tag
    }
    
    // MARK: - Properties
    private var style: Style = .title
    
    // MARK: - Initializers
    init(style: Style) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.style = style
        setTextAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private method
    private func setTextAttributes() {
        switch style {
        case .title:
            font = UIFont(name: "Inter-Medium", size: 16)
            textColor = .blackAmber
        case .subTitle:
            font = UIFont(name: "Inter-Regular", size: 13)
            textColor = .basaltGrey
        case .tag:
            font = UIFont(name: "Inter-Medium", size: 14)
            textColor = .pearlLightGray
        }
    }
}
