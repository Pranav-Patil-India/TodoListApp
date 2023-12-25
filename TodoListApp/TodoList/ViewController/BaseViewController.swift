import UIKit

class BaseViewController: UIViewController {

    // MARK: - Constants

    private static let addButtonDimension = 60.0
    private static let addButtonPadding = 20.0

    // MARK: - Properties

    var isBulkDeleteEnabled = false
    private var tableViewBottomWithDeleteContainer: NSLayoutConstraint?
    private var tableViewBottomWithViewController: NSLayoutConstraint?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()

    private let deleteButtonContainerView = UIView()
    private lazy var seperator: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.backgroundColor = .gray
        return view
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteSelectedItems), for: .touchUpInside)
        return button
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

    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setupTableView()
        setupAddButton()
        setupDeleteButtonContainerView()

        deleteButtonContainerView.isHidden = true

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupDeleteButtonContainerView() {
        view.addSubview(deleteButtonContainerView)
        deleteButtonContainerView.addSubview(seperator)
        deleteButtonContainerView.addSubview(deleteButton)

        deleteButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
        seperator.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        let tableViewBottomWithDeleteContainer = deleteButtonContainerView.topAnchor.constraint(equalTo: tableView.bottomAnchor)
        self.tableViewBottomWithDeleteContainer = tableViewBottomWithDeleteContainer
        var constraints = [tableViewBottomWithDeleteContainer]
        constraints.append(deleteButtonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(deleteButtonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(deleteButtonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor))

        constraints.append(seperator.leadingAnchor.constraint(equalTo: deleteButtonContainerView.leadingAnchor))
        constraints.append(seperator.topAnchor.constraint(equalTo: deleteButtonContainerView.topAnchor))
        constraints.append(seperator.trailingAnchor.constraint(equalTo: deleteButtonContainerView.trailingAnchor))

        constraints.append(deleteButton.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 10))
        constraints.append(deleteButton.leadingAnchor.constraint(equalTo: deleteButtonContainerView.leadingAnchor))
        constraints.append(deleteButton.bottomAnchor.constraint(equalTo: deleteButtonContainerView.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(deleteButton.trailingAnchor.constraint(equalTo: deleteButtonContainerView.trailingAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewBottomWithViewController = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        self.tableViewBottomWithViewController = tableViewBottomWithViewController
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewBottomWithViewController,
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

    private func enterBulkActionDeleteMode() {
        isBulkDeleteEnabled = true
        tableViewBottomWithDeleteContainer?.isActive = true
        tableViewBottomWithViewController?.isActive = false
        deleteButtonContainerView.isHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(exitBulkDelete(sender:)))
        addButton.isHidden = true
        tableView.reloadData()
    }

    // MARK: - Action handler

    @objc func addButtonTapped() {
        assertionFailure("Subclass should implement addButtonTapped().")
    }

    @objc func exitBulkDelete(sender: UIBarButtonItem) {
        tableViewBottomWithDeleteContainer?.isActive = false
        tableViewBottomWithViewController?.isActive = true
        deleteButtonContainerView.isHidden = true
        isBulkDeleteEnabled = false
        navigationItem.hidesBackButton = false
        navigationItem.leftBarButtonItem = nil
        addButton.isHidden = false
        tableView.reloadData()
    }

    @objc func deleteSelectedItems() {
        // TODO: TLA-10 - Delete multiple items
    }

    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        // Enable delete bulk action.
        enterBulkActionDeleteMode()
        navigationItem.title = "Select items"

//        if sender.state == .began {
//            let touchPoint = sender.location(in: tableView)
//            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
//
//            }
//        }
    }

}
