//
//  AddCheckListRowView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 11/4/22.
//

import SwiftUI

struct ModifyTaskView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    @Binding var checkList : [CheckListItemModel]
    
    // Adding binding variables
    @State private var showingAlert = false
    
    let eventItem: EventItemModel
    let eventItemIndex: Int
    let checkListItemIndex: Int
    var checkListItemTask: String? = nil
    
    @State var taskText: String = ""
    // Needs to take in Index of current Event Item for proper storage of checklist
    
    init(checkList              : Binding<[CheckListItemModel]>,
         eventItem              : EventItemModel,
         checkListItemTask      : String? = nil,
         eventItemIndex         : Int,
         checkListItemIndex     : Int) {
        if checkList.isEmpty {
            if let checkListTask = checkListItemTask {
                self._taskText = State(initialValue: checkListTask)
            }
            else {
                self._taskText = State(initialValue: "")
            }
        }
        else {
            // Modifying a existing task, not a temporary one
            if let checkListTask = checkListItemTask {
                self._taskText = State(initialValue: checkListTask)
            }
            else {
                self._taskText = State(initialValue: checkList[checkListItemIndex].task.wrappedValue)
            }
        }

        self.eventItem = eventItem
        self.eventItemIndex = eventItemIndex
        self.checkListItemIndex = checkListItemIndex
        self._checkList = checkList
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    TextEditor(text: $taskText)
                        .scrollContentBackground(.hidden)
                        .background(Color(UIColor.secondarySystemBackground))
                    Text(taskText)
                        .background(Color(UIColor.secondarySystemBackground))
                        .frame(minHeight: 40)
                        .frame(maxWidth: .infinity)
                        .scrollContentBackground(.hidden)
                        .opacity(0)
                }
                
                Button(action: saveButtonPressed , label: {
                    Text("Save Changes".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                })
                
                Button(action: { showingAlert = true } , label: {
                    Text("Delete".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .cornerRadius(10)
                })
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure you want to delete task?"),
                          primaryButton: .destructive(Text("Delete")) {
                        deleteButtonPressed()
                    },
                          secondaryButton: .cancel())
                }
            }
            .padding(14)
            .padding(.top, 450)
        }
        .navigationTitle("Modify Task")
    }
    
    func saveButtonPressed() {
        checkList[checkListItemIndex].task = taskText
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func deleteButtonPressed() {
        checkList.remove(at: checkListItemIndex)
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct ModifyTaskView_Previews: PreviewProvider {
    static var item = EventItemModel(photo: UIImage(systemName: "photo"),
                                     title: "Task 1",
                                     description: "Working on Task 1")
    static var previews: some View {
        NavigationView {
            ModifyTaskView(checkList: .constant([]),
                           eventItem: item,
                           eventItemIndex: 1,
                           checkListItemIndex: 1)
            
        }
        .environmentObject(UserAuthViewModel())
    }
}
