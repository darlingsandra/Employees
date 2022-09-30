//
//  EmployeeListViewController.swift
//  Employees
//
//  Created by Александра Широкова on 02.08.2022.
//

import UIKit

/// Протокол управления view слоем модуля EmployeeList
protocol EmployeeListViewInput: AnyObject {
    /// Установить исходные данные
    func setEmployeeData(_ viewModels: [EmployeeViewModel])
    /// Установить отфильтрованные данные
    func setFilterEmployee(_ viewModels: [EmployeeViewModel])
}

/// Протокол передачи UI - эвентов слою презентации модуля EmployeeList
protocol EmployeeListViewOutput {
    /// Информировать о готовности к загрузки данных
    func readyForLoadData()
    /// Отфильтровать и отсортировать данные
    func filterContent(_ search: String, category: Department)
    /// Показать детальную информацию
    func showDetailsInfo(at id: String)
    /// Показать экран настроек
    func showSettings()
}

final class EmployeeListViewController: UIViewController {

    // MARK: - Properties
    var presenter: EmployeeListViewOutput!
    
    private let assembler = EmployeeListAssembly()
    private var viewModels: [EmployeeViewModel] = [] {
        didSet {
            setSections()
            tableView.reloadData()
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
     
    private var sections: [String] = []
        
    private var keyboardHeight: CGFloat = 0.0 {
        didSet {
            bottomConstraintView.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }
        
    private var category: Department {
        guard customSegmentedControl.tabs.count > 0,
                let index = customSegmentedControl.tabs.firstIndex(of: curentTab)
            else { return .all}
        return Department.allCases[index]
    }
    
    private var typeSort: SettingsSort = SettingsManager.shared.sort {
        didSet {
            presenter.filterContent(searchBar.text ?? "", category: category)
        }
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
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "Sort"), for: .bookmark, state: .normal)
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
        
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        registerCell()
        setupView()
        
        assembler.assembly(viewController: self)
        presenter.readyForLoadData()
        
        registerForKeyboardNotifications()
        registerSettingsObserver()
        
        ThemeManager.applyTheme()
    }
        
    deinit {
        removeKeyboardNotifications()
        removeSettingsObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Settings.sortEmployee.rawValue {
            guard let newValue = change?[.newKey] as? String else { return }
            typeSort = SettingsSort.init(rawValue: newValue) ?? .sortAlphabet
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    @objc func refresh() {
        presenter.readyForLoadData()
    }
    
    @objc func valueChangedTab(sender: UIButton) {
    
        for button in customSegmentedControl.tabs {
            button.isSelected = button == sender
            if button.isSelected {
                curentTab = button
                presenter.filterContent(searchBar.text ?? "", category: category)
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
    
    func setFilterEmployee(_ viewModels: [EmployeeViewModel]) {
        self.viewModels = viewModels
    }
}

// MARK: - UITableViewDataSource
extension EmployeeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if typeSort == .sortBirthday { return sections.count }
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typeSort == .sortBirthday {
            return (viewModels.filter { $0.birthYear == sections[section] }).count
        }
        return viewModels.count
    }
        
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard typeSort == .sortBirthday else { return UIView() }
        
        let sectionView = UIView()
        sectionView.frame = CGRect(x: 0, y: 0, width: 0, height: 68)
                
        let yearLabel = UILabel()
        yearLabel.frame = CGRect(x: 0, y: 0, width: 160, height: 20)
        yearLabel.font = UIFont(name: "Inter-Medium", size: 15)
        yearLabel.textColor = .customPurple
        yearLabel.textAlignment = .center
        yearLabel.text = sections[section]
        
        let leftlineView = UIView()
        leftlineView.backgroundColor = .customPurple
        
        let rightlineView = UIView()
        rightlineView.backgroundColor = .customPurple
        
        let stackView = UIStackView(arrangedSubviews: [leftlineView, yearLabel, rightlineView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        sectionView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -24),
            stackView.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 24),
            stackView.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -24),
            
            yearLabel.widthAnchor.constraint(equalToConstant: 160),
            
            leftlineView.heightAnchor.constraint(equalToConstant: 1),
            rightlineView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        return sectionView
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EmployeeTableViewCell.cellIdentififer,
            for: indexPath) as? EmployeeTableViewCell else {
            return UITableViewCell()
        }
        if typeSort == .sortBirthday {
            let viewModelsSection = viewModels.filter { $0.birthYear == sections[indexPath.section] }
            let viewModel = viewModelsSection[indexPath.row]
            cell.configure(viewModel)
            return cell
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        68.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeeVM = viewModels[indexPath.row]
        presenter.showDetailsInfo(at: employeeVM.id)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.isSelected = false
    }
}

// MARK: - UISearchBarDelegate
extension EmployeeListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterContent(searchBar.text!, category: category)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsBookmarkButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsBookmarkButton = true
        searchBar.endEditing(true)
        
        presenter.filterContent(searchBar.text!, category: category)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        presenter.showSettings()
    }
}

// MARK: - Private method
private extension EmployeeListViewController {
    
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
     
        NSLayoutConstraint.activate([
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
        ])
    }
     
    func registerCell() {
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.cellIdentififer)
    }
     
    func setSections() {
        sections.removeAll()
        guard typeSort == .sortBirthday else { return }
        viewModels.forEach { viewModel in
            if !sections.contains(viewModel.birthYear) { sections.append(viewModel.birthYear) }
        }
    }
    
    func registerSettingsObserver() {
         UserDefaults.standard.addObserver(
            self,
            forKeyPath: Settings.sortEmployee.rawValue,
            options: .new,
            context: nil
        )
    }
    
    func removeSettingsObserver() {
        UserDefaults.standard.removeObserver(self, forKeyPath: Settings.sortEmployee.rawValue)
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

