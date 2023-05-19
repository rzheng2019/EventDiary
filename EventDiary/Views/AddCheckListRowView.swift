//
//  AddCheckListRowView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 11/4/22.

import SwiftUI

struct AddCheckListRowView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var eventListViewModel : EventListViewModel
    
    @State var taskText: String = ""
    
    @Binding var checkList : [CheckListItemModel]
    // Needs to take in Index of current Event Item for proper storage of checklist
    
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
        let checkListItem = CheckListItemModel(task : taskText)
        checkList.append(checkListItem)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddCheckListRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddCheckListRowView(checkList: .constant([]))
        }
        .environmentObject(EventListViewModel())
    }
}
