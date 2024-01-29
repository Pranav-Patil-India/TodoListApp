//
//  ViewDataTransformer.swift
//  TodoListApp
//
//  Created by Pranav Patil on 25/12/23.
//

import Foundation

class ViewDataTransformer {

    static func getTodoListItemViewDatas(from models: [TodoListItemModel]) -> [TodoListItemViewData] {
        return models.map { model in
            return TodoListItemViewData(
                isCompleted: model.isCompleted,
                title: model.title,
                parentCategory: CategoryListItemViewData(name: model.parentCategory?.name),
                shouldDelete: false)
        }
    }

    static func getCategoryListItemViewDatas(from models: [CategoryListItemModel]) -> [CategoryListItemViewData] {
        return models.map { model in
            return CategoryListItemViewData(name: model.name)
        }
    }

}
