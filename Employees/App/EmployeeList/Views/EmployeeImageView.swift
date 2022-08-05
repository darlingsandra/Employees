//
//  EmployeeImageView.swift
//  Employees
//
//  Created by Александра Широкова on 05.08.2022.
//

import UIKit

final class EmployeeImageView: UIImageView {
        
    // MARK: - Initializers
    init(size: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        clipsToBounds = true
        contentMode = .scaleAspectFit
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorderShape()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupBorderShape() {
        let width = bounds.size.width
        layer.cornerRadius = width / 2
    }
}
