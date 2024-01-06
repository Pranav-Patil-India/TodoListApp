//
//  LocalDataService.swift
//  TodoListApp
//
//  Created by Pranav Patil on 23/10/23.
//

import CoreData
import UIKit

class LocalDataService {

    // MARK: - Constants

    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Public helpers

    static func saveContextData() {
        do {
            try context.save()
        } catch {
            print("Error while saving data in core data, error = \(error)")
        }
    }

    // MARK: - Category list

    static func createCategoryListItemModel(name: String) -> CategoryListItemModel {
        let categoryListItemModel = CategoryListItemModel(context: context)
        categoryListItemModel.name = name
        return categoryListItemModel
    }

    static func fetchCategoryData() -> [CategoryListItemModel] {
        let request: NSFetchRequest<CategoryListItemModel> = CategoryListItemModel.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching CategoryListItemModel data, error = \(error)")
            return []
        }
    }

    // MARK: - TODO list

    static func createTodoListItemModel(title: String,
                                        isCompleted: Bool = false,
                                        category: CategoryListItemModel) -> TodoListItemModel {
        let todoListItemModel = TodoListItemModel(context: context)
        todoListItemModel.title = title
        todoListItemModel.parentCategory = category
        todoListItemModel.isCompleted = isCompleted
        return todoListItemModel
    }

    static func fetchTodoListData(category: CategoryListItemModel?) -> [TodoListItemModel] {
        guard let categoryName = category?.name else {
            assertionFailure("Category name cannot be nil")
            return []
        }
        let request: NSFetchRequest<TodoListItemModel> = TodoListItemModel.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching TodoListItemModel data, error = \(error)")
            return []
        }
    }

    static func deleteItems(items: [TodoListItemModel]) {
        items.forEach { context.delete($0) }
        saveContextData()
    }

}
