//
//  LocalDataService.swift
//  TodoListApp
//
//  Created by Pranav Patil on 23/10/23.
//

class LocalDataService {

    private static var dummyData = [
        TodoListModel(title: "Apple", isCompleted: false),
        TodoListModel(title: "Pen", isCompleted: false),
        TodoListModel(title: "Banana", isCompleted: false),
        TodoListModel(title: "Grapes", isCompleted: false)
    ]

    static func fetchDataFromDatabase() -> [TodoListModel] {
        return dummyData
    }

    static func updateData(with data: [TodoListModel]) {
        dummyData = data
    }

}
