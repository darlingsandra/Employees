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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fotoImage, infoStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var skeletonViews = [fotoImage, nameLabel, positionLabel]
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        fotoImage.image = UIImage(named: "Goose")
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
        
        DispatchQueue.global().async {
            NetworkManager.shared.fetchImage(url: viewModel.avatarUrl) { [weak self] result in
                switch result {
                case .success(let dataImage):
                    DispatchQueue.main.async {
                        self?.fotoImage.image = UIImage(data: dataImage)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.fotoImage.image = UIImage(named: "Goose")
                    }
                }
            }
        }
    }
}

// MARK: - Private method
private extension EmployeeTableViewCell {
    private func setupViewCell() {
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate(
            [
                stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                            
                fotoImage.heightAnchor.constraint(equalToConstant: sizeImage),
                fotoImage.widthAnchor.constraint(equalToConstant: sizeImage),
                
                topSpacerView.heightAnchor.constraint(equalToConstant: 16)
            ]
        )
    }
}
