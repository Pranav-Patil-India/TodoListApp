import UIKit

class CategoryListViewController: BaseViewController {

    // MARK: - Properties

    private var categoryList = [CategoryListItemModel]()

    // MARK: - Inits

    override init() {
        super.init()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell")
        tableView.dataSource = self
        tableView.delegate = self

        categoryList = LocalDataService.fetchCategoryData()

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
                let newItem = LocalDataService.createCategoryListItemModel(name: textfieldText)
                self.categoryList.append(newItem)
                LocalDataService.saveContextData()
                self.tableView.reloadData()
            }
        }))

        // Show the alert
        self.present(alert, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categoryList[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TodoListViewController(category: categoryList[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }

}
