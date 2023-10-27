//
//  TodoListViewController.swift
//  TodoListApp
//
//  Created by Pranav Patil on 23/10/23.
//

import UIKit

class TodoListViewController: UIViewController {

    // MARK: - Constants

     private static let addButtonDimension = 60.0
     private static let addButtonPadding = 20.0

    // MARK: - Private properties

    private var todoListData = [TodoListModel]()
    private var isKeyboardVisible = false
    private var userInputContainerViewBottomConstraint: NSLayoutConstraint?
    private lazy var hideKeyboardTapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(hideKeyboard))

    // MARK: - Subviews

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoListCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        let configuration = UIImage.SymbolConfiguration(
            pointSize: Self.addButtonDimension/2,
            weight: .regular,
            scale: .medium)
        addButton.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        addButton.backgroundColor = UIColor.colorFromRGB(rgbValue: 0x6499E9)
        addButton.tintColor = .white
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = Self.addButtonDimension/2
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return addButton
    }()

    private lazy var userInputContainerView: TodoListUserInputContainerView = {
        let containerView = TodoListUserInputContainerView()
        containerView.isHidden = true
        return containerView
    }()

    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)
        todoListData = LocalDataService.fetchDataFromDatabase()
        setupTableView()
        setupAddButton()
        setupUserInputContainerView()

        navigationItem.title = "TODOs"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Keyboard observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    // MARK: - Private methods

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Self.addButtonPadding),
            addButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Self.addButtonPadding),
            addButton.widthAnchor.constraint(equalToConstant: Self.addButtonDimension),
            addButton.heightAnchor.constraint(equalToConstant: Self.addButtonDimension)
        ])
    }

    private func setupUserInputContainerView() {
        view.addSubview(userInputContainerView)
        userInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        let userInputContainerViewBottomConstraint = userInputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            userInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userInputContainerViewBottomConstraint,
            userInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.userInputContainerViewBottomConstraint = userInputContainerViewBottomConstraint
    }

    // MARK: - Action handler

    @objc private func addButtonTapped() {
        userInputContainerView.isHidden = false
        userInputContainerView.inputTextView.becomeFirstResponder()
        view.addGestureRecognizer(hideKeyboardTapGesture)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if !isKeyboardVisible, userInputContainerView.inputTextView.isFirstResponder,
            let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            userInputContainerViewBottomConstraint?.constant -= keyboardSize.height
        }
        isKeyboardVisible = true
    }

    @objc private func keyboardWillHide() {
        isKeyboardVisible = false
        userInputContainerViewBottomConstraint?.constant = 0
        userInputContainerView.isHidden = true
    }

    @objc private func hideKeyboard() {
        userInputContainerView.inputTextView.resignFirstResponder()
        userInputContainerView.resetInputView()
        view.removeGestureRecognizer(hideKeyboardTapGesture)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = todoListData[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            print("Error getting cell")
            return
        }

        // If item is not "checked", we should mark it "completed".
        let shouldMarkAsCompleted = cell.accessoryType == .none
        todoListData[indexPath.row].isCompleted = shouldMarkAsCompleted
        LocalDataService.updateData(with: todoListData)

        cell.accessoryType = shouldMarkAsCompleted ? .checkmark : .none
        cell.alpha = shouldMarkAsCompleted ? 0.5 : 1
    }

}
