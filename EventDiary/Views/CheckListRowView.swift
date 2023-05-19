//
//  CheckListRowView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 11/4/22.
//

import SwiftUI

struct CheckListRowView: View {
    
    let checkListItem : CheckListItemModel
    
    var body: some View {
        HStack {
            Image(systemName: checkListItem.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(checkListItem.isCompleted ? .green : .red)
            
            ZStack {
                Text("  " + checkListItem.task)
                    .frame(width: 350, alignment: .leading)
                    .frame(minHeight: 40)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
            }
            
            Spacer()
        }
    }
}

struct CheckListRowView_Previews: PreviewProvider {
    static var checkListRowFalse = CheckListItemModel(task: "False Placeholder", isCompleted: false)
    static var checkListRowTrue = CheckListItemModel(task: "True Placeholder", isCompleted: true)
    
    static var previews: some View {
            CheckListRowView(checkListItem: checkListRowFalse)
            CheckListRowView(checkListItem: checkListRowTrue)
    }
}
