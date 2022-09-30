//
//  EmployeeSettingsViewController.swift
//  Employees
//
//  Created by Александра Широкова on 23.09.2022.
//

import UIKit

class EmployeeSettingsViewController: UIViewController {
    
    private let padding: CGFloat = 26
    
    private lazy var sortAlphabetButton: RadioButton = {
        let button = RadioButton(title: "По алфавиту")
        button.addTarget(self, action: #selector(tapSettingsButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortBirthdayButton: RadioButton = {
        let button = RadioButton(title: "По дню рождения")
        button.addTarget(self, action: #selector(tapSettingsButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsSort: [SettingsSort : RadioButton] = {
        [ SettingsSort.sortAlphabet : sortAlphabetButton,
          SettingsSort.sortBirthday : sortBirthdayButton]
    }()
    
    private lazy var spacerView: UIView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sortAlphabetButton, sortBirthdayButton, spacerView])
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        fetchSettings()
    }
    
    @objc func tapSettingsButton(sender: RadioButton) {
        settingsSort.forEach { (key: SettingsSort, value: RadioButton) in
            value.isChecked = value == sender
            if value == sender {
                SettingsManager.shared.sort = key
            }
        }
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
}

private extension EmployeeSettingsViewController {
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        
        let titleFont = UIFont(name: "Inter-SemiBold", size: 20) ?? .systemFont(ofSize: 20)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : titleFont]
        title = "Сортировка"
                
        let backButton = UIBarButtonItem(
            image: UIImage(named: "BackImage"),
            style: .plain,
            target: self,
            action: #selector(self.didTapBackButton)
        )
        backButton.tintColor = .black
                
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setupView() {
        self.view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding),
        ])
    }
    
    func fetchSettings() {
        let currentSort = SettingsManager.shared.sort
        settingsSort.forEach { (key: SettingsSort, value: RadioButton) in
            value.isChecked = key == currentSort
        }
    }
}
