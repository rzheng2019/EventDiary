//
//  CheckListItemModel.swift
//  EventDiary
//
//  Created by Ricky Zheng on 11/4/22.
//

import Foundation

struct CheckListItemModel: Identifiable {
    var id: String
    var task: String
    var isCompleted: Bool
    
    init(id: String = UUID().uuidString, task: String, isCompleted: Bool = false) {
        self.id = id
        self.task = task
        self.isCompleted = isCompleted
    }

    func updateCompletion() -> CheckListItemModel {
        return CheckListItemModel(id: id, task: task, isCompleted: !isCompleted)
    }
}
