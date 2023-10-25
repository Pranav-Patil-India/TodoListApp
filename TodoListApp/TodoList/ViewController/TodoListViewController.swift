//
//  TodoListViewController.swift
//  TodoListApp
//
//  Created by Pranav Patil on 23/10/23.
//

import UIKit

class TodoListViewController: UIViewController {

    private static let addButtonDimension = 60.0
    private static let addButtonPadding = 20.0

    private let tableView = UITableView()
    private let addButton = UIButton()
    private var todoListData = [TodoListModel]()

    init() {
        super.init(nibName: nil, bundle: nil)
        todoListData = LocalDataService.fetchDataFromDatabase()
        setupTableView()
        setupAddButton()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoListCell")
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.title = "TODOs"
    }

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
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = Self.addButtonDimension/2
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

        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium)
        addButton.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        addButton.backgroundColor = UIColor.colorFromRGB(rgbValue: 0x6499E9)
        addButton.tintColor = .white
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
