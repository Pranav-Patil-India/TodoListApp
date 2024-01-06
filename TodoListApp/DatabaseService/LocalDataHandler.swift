//
//  LocalDataHandler.swift
//  TodoListApp
//
//  Created by Pranav Patil on 25/12/23.
//

import Foundation

class LocalDataHandler {

    private var todoListItemModels = [TodoListItemModel]()

    func fetchTodoListData(category: CategoryListItemModel?) -> [TodoListItemViewData] {
        todoListItemModels = LocalDataService.fetchTodoListData(category: category)
        return ViewDataTransformer.getTodoListItemViewDatas(from: todoListItemModels)
    }

    func saveTodoListItem(viewData: TodoListItemViewData) -> Bool {
        guard let title = viewData.title, let category = viewData.parentCategory else {
            assertionFailure("Title and Category cannot be nil")
            return false
        }

        for model in todoListItemModels {
            if model.title == title, model.parentCategory == category {
                // TODO: Add support to display popup for "Item already exists"
                return false
            }
        }

        let todoListItemModel = LocalDataService.createTodoListItemModel(
            title: title,
            isCompleted: viewData.isCompleted,
            category: category)
        todoListItemModels.append(todoListItemModel)
        LocalDataService.saveContextData()
        return true
    }

    func updateTodoListItem(viewData: TodoListItemViewData) {
        guard let title = viewData.title, let category = viewData.parentCategory else {
            assertionFailure("Title and Category cannot be nil")
            return
        }

        for model in todoListItemModels {
            if model.title == title, model.parentCategory == category {
                model.isCompleted = viewData.isCompleted
                LocalDataService.saveContextData()
                return
            }
        }
    }

    func deleteTodoListItems(viewDatas: [TodoListItemViewData]) {
        var itemsToDelete = [TodoListItemModel]()
        viewDatas.forEach { viewData in
            let item = todoListItemModels.filter { model in
                return model.title == viewData.title && model.parentCategory == viewData.parentCategory
            }
            itemsToDelete.append(contentsOf: item)
        }


        LocalDataService.deleteItems(items: itemsToDelete)
    }

}
