//
//  DeleteEventTaskView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 11/30/22.
//

import SwiftUI

struct EditEventTaskView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    @Binding var checkList : [CheckListItemModel]
    
    @State private var showingAlert = false
    
    let eventItem: EventItemModel
    let eventItemIndex: Int
    
    var body: some View {
        ZStack {            
            // Check if preview checklist is empty, if so, show existing event item checklist
            if checkList.isEmpty {
                if userAuthViewModel.eventListViewModel.eventItems.isEmpty {
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
                    if userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems.isEmpty
                        || checkList.isEmpty {
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
                        List {
                            ForEach (Array(userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems.enumerated()),
                                     id: \.offset) { index, checkListItem in
                                NavigationLink {
                                    // Go to modify task text page
                                    // Modify page can change text or delete task entirely
                                    ModifyTaskView(checkList            : $checkList,
                                                   eventItem            : eventItem,
                                                   eventItemIndex       : eventItemIndex,
                                                   checkListItemIndex   : index)
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
                            ModifyTaskView(checkList: $checkList,
                                           eventItem: eventItem,
                                           eventItemIndex: eventItemIndex,
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

struct EditEventTaskView_Previews: PreviewProvider {
    static var item = EventItemModel(photo: UIImage(systemName: "photo"),
                                     title: "Task 1",
                                     description: "Working on Task 1")
    
    static var previews: some View {
        EditEventTaskView(checkList: .constant([]),
                          eventItem: item,
                          eventItemIndex: 1)
            .environmentObject(UserAuthViewModel())
    }
}
