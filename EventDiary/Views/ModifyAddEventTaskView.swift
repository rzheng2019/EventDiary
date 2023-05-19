//
//  ModifyAddEventTaskView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 2/15/23.
//

import SwiftUI

struct ModifyAddEventTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var checkList : [CheckListItemModel]
    
    // Adding binding variables
    @State private var showingAlert = false
    
    let checkListItemIndex: Int
    var checkListItemTask: String? = nil
    
    @State var taskText: String = ""
    
    init(checkList              : Binding<[CheckListItemModel]>,
         checkListItemTask      : String? = nil,
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

struct ModifyAddEventTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyAddEventTaskView(checkList: .constant([]), checkListItemIndex: 1)
    }
}
