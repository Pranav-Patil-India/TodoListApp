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
    private var todoListData = [TodoListItemViewData]()
    private var todoListModel = [TodoListItemModel]()
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
        tableView.separatorStyle = .none

        navigationItem.title = category.name

        self.category = category
        todoListModel = LocalDataService.fetchTodoListData(category: category)
        todoListData = todoListModel.map({ model in
            return TodoListItemViewData.getTodoListItemViewData(from: model)
        })
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

    override func exitBulkDelete(sender: UIBarButtonItem) {
        super.exitBulkDelete(sender: sender)
        navigationItem.title = category?.name
        todoListData = todoListData.map({ data in
            data.shouldDelete = false
            return data
        })
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

    private func getCheckboxImage(isTaskCompleted: Bool = false, shouldDelete: Bool = false) -> UIImage? {
        if isBulkDeleteEnabled {
            return shouldDelete ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        }
        return isTaskCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
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
        let todoListData = todoListData[indexPath.row]
        cell.textLabel?.text = todoListData.title
        let isCompleted = todoListData.isCompleted
        cell.imageView?.image = getCheckboxImage(isTaskCompleted: isCompleted, shouldDelete: todoListData.shouldDelete)
        cell.textLabel?.alpha = isCompleted ? 0.5 : 1
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            print("Error getting cell")
            return
        }

        if isBulkDeleteEnabled {
            todoListData[indexPath.row].shouldDelete = isBulkDeleteEnabled && !todoListData[indexPath.row].shouldDelete
            cell.imageView?.image = getCheckboxImage(shouldDelete: todoListData[indexPath.row].shouldDelete)
            return
        }

        let shouldMarkAsCompleted = !todoListModel[indexPath.row].isCompleted
        todoListModel[indexPath.row].isCompleted = shouldMarkAsCompleted
        todoListModel[indexPath.row].parentCategory = category
        LocalDataService.saveContextData()

        todoListData = todoListModel.map({
            TodoListItemViewData.getTodoListItemViewData(from: $0)
        })

        cell.imageView?.image = getCheckboxImage(isTaskCompleted: shouldMarkAsCompleted)
        cell.textLabel?.alpha = shouldMarkAsCompleted ? 0.5 : 1
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title:  "Delete", handler: { [weak self] (
            ac:UIContextualAction,
            view:UIView,
            success:(Bool) -> Void) in
            guard let weakSelf = self else {
                assertionFailure("Self should not be nil")
                return
            }
            LocalDataService.deleteItems(items: [weakSelf.todoListModel[indexPath.row]])
            weakSelf.todoListModel.remove(at: indexPath.row)
            weakSelf.todoListData.remove(at: indexPath.row)
            LocalDataService.saveContextData()
            weakSelf.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteItem.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteItem])
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
        todoListModel.append(newItem)
        LocalDataService.saveContextData()
        todoListData = todoListModel.map({
            TodoListItemViewData.getTodoListItemViewData(from: $0)
        })
        hideKeyboard()
        tableView.reloadData()
    }

}
