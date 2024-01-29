//
//  CategoryListItemViewData.swift
//  TodoListApp
//
//  Created by Pranav Patil on 08/01/24.
//

import Foundation

class CategoryListItemViewData {

    var name: String?
    var shouldDelete: Bool

    init(name: String?, shouldDelete: Bool = false) {
        self.name = name
        self.shouldDelete = shouldDelete
    }

}
