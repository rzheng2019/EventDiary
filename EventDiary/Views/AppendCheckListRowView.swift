//
//  AppendCheckListRowView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 11/16/22.
//

import SwiftUI

struct AppendCheckListRowView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    @Binding var checkList : [CheckListItemModel]
    
    @State var taskText: String = ""
    
    var eventItemIndex: Int = 0
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Enter new task", text: $taskText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                
                Button(action: saveButtonPressed , label: {
                    Text("Save".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                })
            }
            .padding(14)
            .padding(.top, 500)
        }
        .navigationTitle("Add Task")
    }
    
    func saveButtonPressed() {
        
        if checkList.isEmpty {
            checkList = userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems
        }
        
        let newCheckListItem = CheckListItemModel(task: taskText)
        
        checkList.append(newCheckListItem)
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct AppendCheckListRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppendCheckListRowView(checkList: .constant([]))
        }
        .environmentObject(UserAuthViewModel())
    }
}
