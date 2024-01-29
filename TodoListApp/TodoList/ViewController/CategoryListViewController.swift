import UIKit

class CategoryListViewController: BaseViewController {

    // MARK: - Properties

    private var categoryListViewDatas = [CategoryListItemViewData]()
    private lazy var localDataHandler = CategoryListDataHandler()

    // MARK: - Inits

    override init() {
        super.init()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell")
        tableView.dataSource = self
        tableView.delegate = self

        categoryListViewDatas = localDataHandler.fetchCategoryData()

        navigationItem.title = "Categories"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriden methods

    override func addButtonTapped() {
        // Create the alert
        let alert = UIAlertController(
            title: "Add Category",
            message: "Enter the category name for your TODO list",
            preferredStyle: UIAlertController.Style.alert)

        // Add textfield
        alert.addTextField { textfield in
            textfield.placeholder = "Enter category"
        }

        // Add an action (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { _ in
            if let textfieldText = alert.textFields?.first?.text,
               !textfieldText.replacingOccurrences(of: " ", with: "").isEmpty {
                let newItem = CategoryListItemViewData(name: textfieldText)
                if self.localDataHandler.saveCategoryListItem(viewData: newItem) {
                    self.categoryListViewDatas.append(newItem)
                    self.tableView.reloadData()
                }
            }
        }))

        // Show the alert
        present(alert, animated: true, completion: nil)
    }

    override func exitBulkDelete() {
        super.exitBulkDelete()
        navigationItem.title = "Categories"
    }

    override func deleteSelectedItems() {
        let itemsToDelete = categoryListViewDatas.filter { $0.shouldDelete }
        categoryListViewDatas.removeAll { $0.shouldDelete }
        localDataHandler.deleteCategoryListItems(viewDatas: itemsToDelete)
        exitBulkDelete()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryListViewDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categoryListViewDatas[indexPath.row].name
        cell.accessoryType = isBulkDeleteEnabled ? .none : .disclosureIndicator
        cell.imageView?.image = isBulkDeleteEnabled ? UIImage(systemName: "square") : nil
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSelectedCategory = categoryListViewDatas[indexPath.row]
        if isBulkDeleteEnabled, let cell = tableView.cellForRow(at: indexPath) {
            let shouldDelete = currentSelectedCategory.shouldDelete
            cell.imageView?.image = shouldDelete
            ? UIImage(systemName: "square")
            : UIImage(systemName: "checkmark.square.fill")
            currentSelectedCategory.shouldDelete = !shouldDelete
            return
        }
        let vc = TodoListViewController(category: currentSelectedCategory)
        navigationController?.pushViewController(vc, animated: true)
    }

}
