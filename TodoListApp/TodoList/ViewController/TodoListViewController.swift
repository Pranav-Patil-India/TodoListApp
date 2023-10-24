//
//  TodoListViewController.swift
//  TodoListApp
//
//  Created by Pranav Patil on 23/10/23.
//

import UIKit

class TodoListViewController: UITableViewController {

    private var todoListData = [TodoListModel]()

    init() {
        super.init(nibName: nil, bundle: nil)
        todoListData = LocalDataService.fetchDataFromDatabase()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "TODOs"
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = todoListData[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
