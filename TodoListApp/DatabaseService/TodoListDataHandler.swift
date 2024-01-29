//
//  LocalDataHandler.swift
//  TodoListApp
//
//  Created by Pranav Patil on 25/12/23.
//

import Foundation

class TodoListDataHandler {

    private var todoListItemModels = [TodoListItemModel]()

    func fetchTodoListData(category: CategoryListItemViewData?) -> [TodoListItemViewData] {
        todoListItemModels = LocalDataService.fetchTodoListData(categoryName: category?.name)
        return ViewDataTransformer.getTodoListItemViewDatas(from: todoListItemModels)
    }

    func saveTodoListItem(viewData: TodoListItemViewData) -> Bool {
        let category = LocalDataService.fetchCategoryData(for: viewData.parentCategory?.name).first
        guard let title = viewData.title, let category else {
            assertionFailure("Title and Category cannot be nil")
            return false
        }

        for model in todoListItemModels {
            if model.title == title, model.parentCategory?.name == category.name {
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
            if model.title == title, model.parentCategory?.name == category.name {
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
                return model.title == viewData.title && model.parentCategory?.name == viewData.parentCategory?.name
            }
            itemsToDelete.append(contentsOf: item)
        }

        LocalDataService.deleteItems(items: itemsToDelete)
    }

}
