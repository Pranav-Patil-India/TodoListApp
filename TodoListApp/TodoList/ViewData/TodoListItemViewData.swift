//
//  TodoListItemViewData.swift
//  TodoListApp
//
//  Created by Pranav Patil on 18/12/23.
//

import Foundation

class TodoListItemViewData {

    var isCompleted: Bool
    var title: String?
    var parentCategory: CategoryListItemViewData?
    var shouldDelete: Bool

    init(isCompleted: Bool, title: String?, parentCategory: CategoryListItemViewData?, shouldDelete: Bool = false) {
        self.isCompleted = isCompleted
        self.title = title
        self.parentCategory = parentCategory
        self.shouldDelete = shouldDelete
    }

}
