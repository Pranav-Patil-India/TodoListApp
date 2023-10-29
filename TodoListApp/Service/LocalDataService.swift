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

    static func createTodoListItemModel(title: String, isCompleted: Bool = false) -> TodoListItemModel {
        let todoListItemModel = TodoListItemModel(context: context)
        todoListItemModel.title = title
        todoListItemModel.isCompleted = isCompleted
        return todoListItemModel
    }

    static func saveContextData() {
        do {
            try context.save()
        } catch {
            print("Error while saving data in core data, error = \(error)")
        }
    }

    static func fetchData() -> [TodoListItemModel] {
        let request: NSFetchRequest<TodoListItemModel> = TodoListItemModel.fetchRequest()
        do {
            return  try context.fetch(request)
        } catch {
            print("Error fetching data, error = \(error)")
            return []
        }
    }

}
