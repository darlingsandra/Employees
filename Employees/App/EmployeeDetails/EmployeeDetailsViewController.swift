//
//  EmployeeDetailsViewController.swift
//  Employees
//
//  Created by Александра Широкова on 16.08.2022.
//

import UIKit

/// Протокол управления view слоем модуля EmployeeDetails
protocol EmployeeDetailsViewInput: AnyObject {
    /// Установить данные
    func setEmployeeData(viewModel: EmployeeDetailsViewModel)
}

/// Протокол передачи UI - эвентов слою презентации модуля EmployeeDetails
protocol EmployeeDetailsViewOutput {
    /// готов к отображению данных
    func readyShowData()
}

class EmployeeDetailsViewController: UIViewController {

    // MARK: - Properties
    var presenter: EmployeeDetailsViewOutput!
    
    private let sizeImage: CGFloat = 104
    private let assembler = EmployeeErrorAssembly()
    private var viewModel: EmployeeDetailsViewModel? {
        didSet {
            fullNameLabel.text = viewModel?.fullName
            tagLabel.text = viewModel?.tag
            positionLabel.text = viewModel?.position
            birthdayLabel.text = viewModel?.birthday
            ageLabel.text = viewModel?.age
            setTitlePhone(button: phoneButton, title: viewModel?.phone ?? "")
        }
    }
        
    private lazy var fotoImage = EmployeeImageView(size: sizeImage)
    
    private lazy var topSpacerView = UIView()
    private lazy var bottomSpacerView = UIView()
    
    private var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Bold", size: 24)
        label.textColor = .blackAmber
        label.textAlignment = .center
        return label
    }()
    
    private var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 17)
        label.textColor = .pearlLightGray
        label.textAlignment = .center
        return label
    }()
    
    private var positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 13)
        label.textColor = .basaltGrey
        label.textAlignment = .center
        return label
    }()
    
    private var birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 16)
        label.textColor = .blackAmber
        return label
    }()
    
    private var ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 16)
        label.textColor = .pearlLightGray
        return label
    }()
    
    private lazy var phoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.blackAmber, for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.addTarget(self, action: #selector(tapPhoneButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), fullNameLabel, tagLabel, UIView()])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameStackView, positionLabel])
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fotoImage, infoStackView])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
        
    private lazy var detailsStackView: UIStackView = {
        let birthdayStackView = getDetailsRowView(icon: "star", element: birthdayLabel)
        let phoneStackView = getDetailsRowView(icon: "phone", element: phoneButton)
        let stackViewAge = UIStackView(arrangedSubviews: [birthdayStackView, ageLabel])
        stackViewAge.distribution = .equalSpacing
        let stackView = UIStackView(arrangedSubviews: [stackViewAge, phoneStackView, bottomSpacerView])
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.spacing = 48
        return stackView
    }()
        
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:
                                        [topSpacerView,
                                         mainStackView,
                                         detailsStackView
                                        ]
                                    )
        stackView.backgroundColor = .lightGray
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fotoImage.image = UIImage(named: "Goose")
        presenter.readyShowData()
        setupNavigationBar()
        setupView()
    }
    
    @objc func tapPhoneButton() {
        if let url = URL(string: "tel://\(viewModel?.call ?? "")") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - EmployeeDetailsViewInput
extension EmployeeDetailsViewController: EmployeeDetailsViewInput {
    func setEmployeeData(viewModel: EmployeeDetailsViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private method
private extension EmployeeDetailsViewController {
    
    func setupView() {
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
                
        mainStackView.layoutMargins = UIEdgeInsets(top: -24, left: 0, bottom: 24, right: 0)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        detailsStackView.layoutMargins = UIEdgeInsets(top: 27, left: 20, bottom: 0, right: 20)
        detailsStackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            topSpacerView.heightAnchor.constraint(equalToConstant: 72),
            fotoImage.heightAnchor.constraint(equalToConstant: sizeImage),
            
            birthdayLabel.heightAnchor.constraint(equalToConstant: 20),
            phoneButton.heightAnchor.constraint(equalToConstant: 20),

            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNavigationBar() {     
        let backButton = UIBarButtonItem(
            image: UIImage(named: "BackImage"),
            style: .plain,
            target: self,
            action: #selector(self.didTapBackButton)
        )
        backButton.tintColor = .black
                
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setTitlePhone(button: UIButton, title: String) {
        let attributedFont = UIFont(name: "Inter-Medium", size: 16) ?? .systemFont(ofSize: 16)
        let attributedText = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.font: attributedFont]
        )
        button.setAttributedTitle(attributedText, for: .normal)
    }
    
    func getDetailsRowView<T: UIView>(icon: String, element: T) -> UIStackView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: icon)
        imageView.tintColor = .blackAmber
        NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)])
        let stackView = UIStackView(arrangedSubviews: [imageView, element])
        stackView.spacing = 12
        return stackView
    }
}
