//
//  EmployeeTableViewCell.swift
//  Employees
//
//  Created by Александра Широкова on 05.08.2022.
//

import UIKit

final class EmployeeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    let nameLabel = EmployeeInfoLabel(style: .title)
    let positionLabel = EmployeeInfoLabel(style: .subTitle)
    let tagLabel = EmployeeInfoLabel(style: .tag)
    
    static let cellIdentififer = "Cell"
    
    private var viewModel: EmployeeViewModel?
    
    private let sizeImage: CGFloat = 72
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var fotoImage = EmployeeImageView(size: sizeImage)
    private lazy var trailingSpacerView = UIView()
    private lazy var bottomSpacerView = UIView()
    private lazy var topSpacerView = UIView()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, tagLabel, trailingSpacerView])
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topSpacerView, nameStackView, positionLabel, bottomSpacerView])
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var birthdayLabel: UILabel = {
        let birthdayLabel = UILabel()
        birthdayLabel.frame = CGRect(x: 0, y: 0, width: 96, height: 48)
        birthdayLabel.font =  UIFont(name: "Inter-Regular", size: 15)
        birthdayLabel.textColor = .basaltGrey
        birthdayLabel.textAlignment = .right
        return birthdayLabel
    }()
    
    private lazy var birthdayStackView: UIStackView = {
        let birthdayStackView = UIStackView(arrangedSubviews: [birthdayLabel])
        return birthdayStackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fotoImage, infoStackView, birthdayStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
        
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        setupViewCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    func configure(_ viewModel: EmployeeViewModel) {
        self.viewModel = viewModel
        
        nameLabel.text = viewModel.fullName
        tagLabel.text = viewModel.tag
        positionLabel.text = viewModel.position
        birthdayLabel.text = SettingsManager.shared.sort == .sortBirthday ? viewModel.birthDay : ""
        
        NetworkManager.shared.fetchImage(url: viewModel.avatarUrl) { image in
            self.fotoImage.image = image
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
}

// MARK: - Private method
private extension EmployeeTableViewCell {
    private func setupViewCell() {
        self.contentView.addSubview(stackView)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        fotoImage.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                        
            fotoImage.heightAnchor.constraint(equalToConstant: sizeImage),
            fotoImage.widthAnchor.constraint(equalToConstant: sizeImage),
            
            topSpacerView.heightAnchor.constraint(equalToConstant: 16),
            
            birthdayStackView.topAnchor.constraint(equalTo: stackView.topAnchor),
            birthdayStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: fotoImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: fotoImage.centerYAnchor),
        ])
    }
}
