import UIKit

class BaseViewController: UIViewController {

    // MARK: - Constants

    private static let addButtonDimension = 60.0
    private static let addButtonPadding = 20.0

    // MARK: - Subviews

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.keyboardDismissMode = .interactive
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

    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)
        setupTableView()
        setupAddButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
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

    // MARK: - Action handler

    @objc func addButtonTapped() {
        assertionFailure("Subclass should implement addButtonTapped().")
    }

}
