//
//  EmployeeListViewController.swift
//  Employees
//
//  Created by Александра Широкова on 02.08.2022.
//

import UIKit

/// Протокол управления view слоем модуля EmployeeList
protocol EmployeeListViewInput: AnyObject {
    /// Установить данные
    func setEmployeeData(_ viewModels: [EmployeeViewModel])
}

/// Протокол передачи UI - эвентов слою презентации модуля EmployeeList
protocol EmployeeListViewOutput {
    /// Инфоррмировать о готовности к загрузки данных
    func readyForLoadData()
}

final class EmployeeListViewController: UIViewController {

    // MARK: - Properties
    var presenter: EmployeeListViewOutput!
    
    private let cellIdentififer = "Cell"
    private var viewModels: [EmployeeViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let assembler = EmployeeListAssembly()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        registerCell()
        setupView()
        
        assembler.assembly(viewController: self)
        presenter.readyForLoadData()
    }
}

// MARK: - EmployeeListViewInput
extension EmployeeListViewController: EmployeeListViewInput {
    func setEmployeeData(_ viewModels: [EmployeeViewModel]) {
        self.viewModels = viewModels
    }
}

// MARK: - UITableViewDataSource
extension EmployeeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentififer, for: indexPath)
        let viewModel = viewModels[indexPath.row]
        cell.textLabel?.text = viewModel.firstName
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EmployeeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44.0
    }
}

// MARK: - Private method
private extension EmployeeListViewController {
    
    func registerCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentififer)
    }
    
    func setupView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
    }
}
