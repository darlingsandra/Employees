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
    /// Информировать о готовности к загрузки данных
    func readyForLoadData()
    func showDetailsInfo(at index: Int)
}

final class EmployeeListViewController: UIViewController {

    // MARK: - Properties
    var presenter: EmployeeListViewOutput!
    var refreshControl: UIRefreshControl!
    
    private var viewModels: [EmployeeViewModel] = [] {
        didSet {
            tableView.reloadData()
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
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
        
        title = "Employee"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        registerCell()
        setupView()
        
        assembler.assembly(viewController: self)
        presenter.readyForLoadData()
    }
    
    @objc func refresh() {
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EmployeeTableViewCell.cellIdentififer,
            for: indexPath) as? EmployeeTableViewCell else {
            return UITableViewCell()
        }
        let viewModel = viewModels[indexPath.row]
        cell.configure(viewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EmployeeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetailsInfo(at: indexPath.row)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.isSelected = false
    }
}

// MARK: - Private method
private extension EmployeeListViewController {
    
    func registerCell() {
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.cellIdentififer)
    }
    
    func setupView() {
        self.view.addSubview(tableView)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
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
