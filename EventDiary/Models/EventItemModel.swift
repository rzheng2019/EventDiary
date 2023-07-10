//
//  EventItemModel.swift
//  EventDiary
//
//  Created by Ricky Zheng on 10/19/22.
//

import PhotosUI
import Foundation

// Model for each EventBoardListView Row

struct EventItemModel: Identifiable {
    // Data for Title, Photo, Description
    var id: String
    var photo: UIImage?
    var title: String?
    var description: String?
    // Checklist
    var checkListItems : [CheckListItemModel]
    
    init(id: String = UUID().uuidString, photo: UIImage?, title: String, description: String, checkListItems: [CheckListItemModel] = []) {
        self.id = id
        self.photo = photo
        self.title = title
        self.description = description
        self.checkListItems = checkListItems
    }
}
