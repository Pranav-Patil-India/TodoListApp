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
                parentCategory: model.parentCategory,
                shouldDelete: false)
        }
    }

}
