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
    func showDetailsInfo(at id: String)
}

final class EmployeeListViewController: UIViewController {

    // MARK: - Properties
    var presenter: EmployeeListViewOutput!
    
    private let assembler = EmployeeListAssembly()
    private var viewModels: [EmployeeViewModel] = [] {
        didSet {
            filterContentForSearchText(searchBar.text ?? "", category: category)
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
    private var filteredViewModels: [EmployeeViewModel] = [] {
        didSet {
            tableView.reloadData()
            if dataLoadingFinished {
                employeeNoFoundView.isHidden = !(filteredViewModels.count == 0)
            }
        }
    }
    
    private var keyboardHeight: CGFloat = 0.0 {
        didSet {
            bottomConstraintView.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }
    
    private var isSearchBarEmpty: Bool {
      return searchBar.text?.isEmpty ?? true
    }
    
    private var category: Department {
        guard customSegmentedControl.tabs.count > 0,
                let index = customSegmentedControl.tabs.firstIndex(of: curentTab)
            else { return .all}
        return Department.allCases[index]
    }
    
    private var dataLoadingFinished: Bool = false
    private var bottomConstraintView: NSLayoutConstraint!
    private var curentTab: CustomSegmentedButton!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
         
    private lazy var topView: UIView = {
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.font = UIFont(name: "Inter-Medium", size: 15) ?? .systemFont(ofSize: 15)
        textField?.spellCheckingType = .no
        textField?.autocorrectionType = .no
        searchBar.placeholder = "Введи имя, тег..."
        searchBar.setValue("Отмена", forKey: "cancelButtonText")
        return searchBar
    }()
    
    private lazy var customSegmentedControl: CustomSegmentedControl = {
        let customSegmentedControl = CustomSegmentedControl(items:  Department.allCases.map { $0.rawValue } )
        customSegmentedControl.addTarget(self, action: #selector(valueChangedTab(sender: )))
        curentTab = customSegmentedControl.tabs.first
        return customSegmentedControl
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var employeeNoFoundView: EmployeeNoFound = EmployeeNoFound()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Employee"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        registerCell()
        setupView()
        
        assembler.assembly(viewController: self)
        presenter.readyForLoadData()
        
        registerForKeyboardNotifications()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func refresh() {
        presenter.readyForLoadData()
    }
    
    @objc func valueChangedTab(sender: UIButton) {
    
        for button in customSegmentedControl.tabs {
            button.isSelected = button == sender
            if button.isSelected {
                curentTab = button
                filterContentForSearchText(searchBar.text ?? "", category: category)
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
    }
}

// MARK: - EmployeeListViewInput
extension EmployeeListViewController: EmployeeListViewInput {
    func setEmployeeData(_ viewModels: [EmployeeViewModel]) {
        self.viewModels = viewModels
        dataLoadingFinished = true
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
        let employeeVM = filteredViewModels[indexPath.row]
        presenter.showDetailsInfo(at: employeeVM.id)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.isSelected = false
    }
}

// MARK: - UISearchBarDelegate
extension EmployeeListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!, category: category)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        filterContentForSearchText(searchBar.text!, category: category)
    }
}

// MARK: - Private method
private extension EmployeeListViewController {
    
    func registerCell() {
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.cellIdentififer)
    }
    
    func setupView() {
        self.view.addSubview(tableView)
        tableView.addSubview(refreshControl)
                        
        topView.addSubview(searchBar)
        topView.addSubview(customSegmentedControl)
        
        self.view.addSubview(employeeNoFoundView)
        self.view.addSubview(topView)
        
        view.backgroundColor = .white
        
        employeeNoFoundView.isHidden = true
        bottomConstraintView = employeeNoFoundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
     
        NSLayoutConstraint.activate(
            [
                topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                topView.heightAnchor.constraint(equalToConstant: 90),
                
                tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                employeeNoFoundView.topAnchor.constraint(equalTo: topView.bottomAnchor),
                employeeNoFoundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                employeeNoFoundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomConstraintView,
                
                searchBar.topAnchor.constraint(equalTo: topView.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8),
                searchBar.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8),
                searchBar.heightAnchor.constraint(equalToConstant: 40),
                
                customSegmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 14),
                customSegmentedControl.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
                customSegmentedControl.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
                customSegmentedControl.heightAnchor.constraint(equalToConstant: 36),
            ]
        )
    }
    
    func filterContentForSearchText(_ searchText: String, category: Department = .all) {
        filteredViewModels = viewModels.filter { (employee: EmployeeViewModel) -> Bool in
            let doesCategoryMatch = category == .all || employee.department == category.name
            
            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                let doesSearch = employee.fullName.lowercased().contains(searchText.lowercased())
                    || employee.tag.lowercased().contains(searchText.lowercased())
                
                return doesCategoryMatch && doesSearch
            }
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

