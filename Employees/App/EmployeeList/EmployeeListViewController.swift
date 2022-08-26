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
    
    private var viewModels: [EmployeeViewModel] = [] {
        didSet {
            searchData()
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
    private var filteredViewModels: [EmployeeViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var curentTab: CustomSegmentedButton!
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let assembler = EmployeeListAssembly()
        
    private var refreshControl: UIRefreshControl!
    private var customSegmentedControl: CustomSegmentedControl!

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
    
    @objc func valueChangedTab(sender: UIButton) {
    
        for button in customSegmentedControl.tabs {
            button.isSelected = button == sender
            if button.isSelected {
                curentTab = button
                searchData()
            }
        }
    }
    
    func searchData() {
        guard let index = customSegmentedControl.tabs.firstIndex(of: curentTab) else { return }
        let filter = Department.allCases[index]
        if filter != Department.all {
            filteredViewModels = viewModels.filter { $0.department == filter.name}
        } else {
            filteredViewModels = viewModels
        }
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
        filteredViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EmployeeTableViewCell.cellIdentififer,
            for: indexPath) as? EmployeeTableViewCell else {
            return UITableViewCell()
        }
        let viewModel = filteredViewModels[indexPath.row]
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
        
        let segmentedControlWidth = navigationController?.navigationBar.frame.size.width ?? 0
        customSegmentedControl = CustomSegmentedControl(items:  Department.allCases.map { $0.rawValue } )
        customSegmentedControl.addTarget(self, action: #selector(valueChangedTab(sender: )))
        customSegmentedControl.frame = CGRect(x: 0, y: 0, width: segmentedControlWidth, height: 50)
        navigationItem.titleView = customSegmentedControl
        curentTab = customSegmentedControl.tabs.first
        
        navigationItem.titleView?.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView?.setNeedsLayout()
        navigationItem.titleView?.layoutIfNeeded()
        navigationItem.titleView?.translatesAutoresizingMaskIntoConstraints = true
        
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
