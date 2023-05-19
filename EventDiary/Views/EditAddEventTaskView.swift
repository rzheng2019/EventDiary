//
//  EditAddEventTaskView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 2/15/23.
//

import SwiftUI

struct EditAddEventTaskView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var checkList : [CheckListItemModel]
    
    @State private var showingAlert = false

    var body: some View {
        ZStack {
            // Check if preview checklist is empty, if so, show existing event item checklist
            if checkList.isEmpty {
                VStack {
                    Text("No Tasks in To Do List to Delete")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 25))
                    Text("Please Add a New Task!")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 25))
                }
            }
            else {
                // For when task are in the process of creation but not saved
                // Still show temp checkListItems if no tasks have been saved
                List {
                    // Need checklist item index
                    ForEach (Array(checkList.enumerated()),
                             id: \.offset) { index, checkListItem in
                        NavigationLink {
                            // Go to modify task text page
                            // Modify page can change text or delete task entirely
                            ModifyAddEventTaskView(checkList: $checkList,
                                                   checkListItemIndex: index)
                        } label: {
                            CheckListRowView(checkListItem: checkListItem)
                                .listRowSeparator(.hidden)
                                .padding(.leading, 7)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct EditAddEventTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditAddEventTaskView(checkList: .constant([]))
    }
}

