//
//  TodoListItemCell.swift
//  TodoListApp
//
//  Created by Pranav Patil on 29/01/24.
//

import Foundation
import UIKit

protocol TodoListItemCellDelegate {
    func updateTodoListItem(viewData: TodoListItemViewData, shouldUpdateLocalDatabase: Bool)
}

class TodoListItemCell: UITableViewCell {

    var delegate: TodoListItemCellDelegate?
    private var viewData: TodoListItemViewData?
    private var isBulkDeleteEnabled: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewData: TodoListItemViewData, isBulkDeleteEnabled: Bool) {
        self.viewData = viewData
        self.isBulkDeleteEnabled = isBulkDeleteEnabled
        textLabel?.text = viewData.title
        let isCompleted = viewData.isCompleted
        imageView?.image = getCheckboxImage(
            isTaskCompleted: isCompleted,
            shouldDelete: viewData.shouldDelete)
        textLabel?.alpha = isCompleted ? 0.5 : 1
    }

    private func setupSubviews() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView?.isUserInteractionEnabled = true
        imageView?.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let viewData else {
            return
        }

        if isBulkDeleteEnabled {
            viewData.shouldDelete = !viewData.shouldDelete
            imageView?.image = getCheckboxImage(shouldDelete: viewData.shouldDelete)
            delegate?.updateTodoListItem(viewData: viewData, shouldUpdateLocalDatabase: false)
            return
        }

        let shouldMarkAsCompleted = !viewData.isCompleted
        viewData.isCompleted = shouldMarkAsCompleted
        delegate?.updateTodoListItem(viewData: viewData, shouldUpdateLocalDatabase: true)

        imageView?.image = getCheckboxImage(isTaskCompleted: shouldMarkAsCompleted)
        textLabel?.alpha = shouldMarkAsCompleted ? 0.5 : 1
    }

    private func getCheckboxImage(isTaskCompleted: Bool = false, shouldDelete: Bool = false) -> UIImage? {
        if isBulkDeleteEnabled {
            return shouldDelete ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        }
        return isTaskCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
    }

}
