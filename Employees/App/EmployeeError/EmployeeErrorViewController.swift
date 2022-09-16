//
//  EmployeeErrorViewController.swift
//  Employees
//
//  Created by Александра Широкова on 10.08.2022.
//

import UIKit

protocol EmployeeErrorViewInput: AnyObject {}

/// Протокол передачи UI - эвентов слою презентации модуля EmployeeError
protocol EmployeeErrorViewOutput {
    /// Обновить данные
    func readyForUpdateData()
}

class EmployeeErrorViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: EmployeeErrorViewOutput!
    private let assembler = EmployeeErrorAssembly()
    
    private var sizeImage: CGFloat = 56
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Flying-saucer")
        return imageView
    }()
    
    private let brokenLabel: UILabel = {
        let label = UILabel()
        label.text = "Какой-то сверхразум все сломал"
        label.textColor = .blackAmber
        label.font = UIFont(name: "Inter-SemiBold", size: 17)
        label.textAlignment = .center
        return label
    }()
    
    private let fixLabel: UILabel = {
        let label = UILabel()
        label.text = "Постараемся быстро починить"
        label.textColor = .pearlLightGray
        label.font = UIFont(name: "Inter-Regular", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedFont = UIFont(name: "Inter-SemiBold", size: 16) ?? .systemFont(ofSize: 16)
        let attributedText = NSAttributedString(
            string: "Попробовать снова",
            attributes: [NSAttributedString.Key.font: attributedFont]
        )
        button.setTitleColor(UIColor.systemIndigo, for: .normal)
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(tapUpdateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var topSpacerView = UIView()
    private lazy var bottomSpacerView = UIView()
    private lazy var leftSpacerView = UIView()
    private lazy var rightSpacerView = UIView()
     
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [brokenLabel, fixLabel, updateButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftSpacerView, imageView, rightSpacerView])
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageStackView, textStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topSpacerView, infoStackView, bottomSpacerView])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func tapUpdateButton() {
        presenter.readyForUpdateData()
        dismiss(animated: true)
    }
}

// MARK: - Private method
private extension EmployeeErrorViewController {
    func setupView() {
        view.backgroundColor = .white
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                imageView.heightAnchor.constraint(equalToConstant: sizeImage),
                imageView.widthAnchor.constraint(equalToConstant: sizeImage),
                
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
                stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ]
        )
    }
}

// MARK: - EmployeeErrorViewInput
extension EmployeeErrorViewController: EmployeeErrorViewInput {}
