//
//  CategoryListDataHandler.swift
//  TodoListApp
//
//  Created by Pranav Patil on 21/01/24.
//

import Foundation

class CategoryListDataHandler {

    private var categoryListItemModels = [CategoryListItemModel]()

    func saveCategoryListItem(viewData: CategoryListItemViewData) -> Bool {
        guard let name = viewData.name else {
            assertionFailure("Name of the category cannot be nil")
            return false
        }

        for model in categoryListItemModels {
            if model.name == name {
                // TODO: Add support to display popup for "Item already exists"
                return false
            }
        }

        let newItem = LocalDataService.createCategoryListItemModel(name: name)
        categoryListItemModels.append(newItem)
        LocalDataService.saveContextData()
        return true
    }

    func fetchCategoryData() -> [CategoryListItemViewData] {
        categoryListItemModels = LocalDataService.fetchCategoryData()
        return ViewDataTransformer.getCategoryListItemViewDatas(from: categoryListItemModels)
    }

    func deleteCategoryListItems(viewDatas: [CategoryListItemViewData]) {
        var itemsToDelete = [CategoryListItemModel]()
        viewDatas.forEach { viewData in
            let item = categoryListItemModels.filter { model in
                return model.name == viewData.name
            }
            itemsToDelete.append(contentsOf: item)
        }

        LocalDataService.deleteCategoryItems(items: itemsToDelete)
    }

}
