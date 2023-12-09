//
//  TodoListViewController.swift
//  TodoListApp
//
//  Created by Pranav Patil on 23/10/23.
//

import CoreData
import UIKit

class TodoListViewController: BaseViewController {

    // MARK: - Private properties

    private var category: CategoryListItemModel?
    private var todoListData = [TodoListItemModel]()
    private var isKeyboardVisible = false
    private var userInputContainerViewBottomConstraint: NSLayoutConstraint?
    private lazy var hideKeyboardTapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(hideKeyboard))

    private lazy var userInputContainerView: TodoListUserInputContainerView = {
        let containerView = TodoListUserInputContainerView(delegate: self)
        containerView.isHidden = true
        return containerView
    }()

    // MARK: - Inits

    init(category: CategoryListItemModel) {
        super.init()

        setupUserInputContainerView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoListCell")
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.title = category.name

        self.category = category
        todoListData = LocalDataService.fetchTodoListData(category: category)
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

    override func addButtonTapped() {
        userInputContainerView.isHidden = false
        userInputContainerView.inputTextView.becomeFirstResponder()
        view.addGestureRecognizer(hideKeyboardTapGesture)
    }

    // MARK: - Private methods

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
        let isCompleted = todoListData[indexPath.row].isCompleted
        cell.accessoryType = isCompleted ? .checkmark : .none
        cell.contentView.alpha = isCompleted ? 0.5 : 1
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
        todoListData[indexPath.row].parentCategory = category
        LocalDataService.saveContextData()

        cell.accessoryType = shouldMarkAsCompleted ? .checkmark : .none
        cell.contentView.alpha = shouldMarkAsCompleted ? 0.5 : 1
    }

}

// MARK: - TodoListUserInputContainerViewDelegate

extension TodoListViewController: TodoListUserInputContainerViewDelegate {

    func saveButtonTapped(inputText: String) {
        guard let category = category else {
            assertionFailure("Category cannot be nil")
            return
        }
        let newItem = LocalDataService.createTodoListItemModel(title: inputText, category: category)
        todoListData.append(newItem)
        LocalDataService.saveContextData()
        hideKeyboard()
        tableView.reloadData()
    }

}
