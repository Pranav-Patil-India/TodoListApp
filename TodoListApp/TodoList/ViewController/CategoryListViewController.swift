import UIKit

class CategoryListViewController: BaseViewController {

    // MARK: - Inits

    override init() {
        super.init()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell")
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.title = "Categories"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalDataService.dummyStrings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = LocalDataService.dummyStrings[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TodoListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
