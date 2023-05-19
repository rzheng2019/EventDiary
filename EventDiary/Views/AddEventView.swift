//
//  ContentView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 10/7/22.
//

import PhotosUI
import Firebase
import SwiftUI

struct AddEventView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    @State var checkList : [CheckListItemModel] = []
    @State var description : String = ""
    @State var title: String = ""
    @State var photoItem: PhotoItem = PhotoItem()
    
    let hikerBackgroundColor : UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    var photoSelected: UIImage?
    
    var body: some View {
        ScrollView {
            Section(header:
                        Text("Add Event Details")
                .font(.system(size: 30))
                .font(.headline)
                .fontWeight(.bold))
            {}
                .padding(.trailing, 132)
                .padding(.bottom, 5)

            addTitleSection(title: $title)
            
            addPhotoSection(photoItem: $photoItem)
    
            addDescriptionSection(description: $description)
            
            addToDoListSection(checkList: $checkList)
            
            // Save Button
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("+ Save Event \(Image(systemName: "figure.hiking"))")
                    .foregroundColor(.black)
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(width: 200, height: 50)
                    .background(Color(hikerBackgroundColor))
                    .cornerRadius(150)
            })
        }
    }
    
    func saveButtonPressed() {
        if let selectedImageItem = photoItem.selectedImageItem, // Unwrap
           let uiImage = UIImage(data: selectedImageItem) {
            userAuthViewModel.eventListViewModel.addEventItem(photo: uiImage,
                                                              title: title,
                                                              description: description,
                                                              checkListItems: checkList)
            
            userAuthViewModel.eventListViewModel.uploadEventItem(photo: uiImage,
                                                                 title: title,
                                                                 description: description,
                                                                 checkListItems: checkList)
            
            // Reload view model to reflect current Firebase data
            userAuthViewModel.objectWillChange.send()
            
            presentationMode.wrappedValue.dismiss()
        }
        else {
            userAuthViewModel.eventListViewModel.addEventItem(photo: nil,
                                                              title: title,
                                                              description: description,
                                                              checkListItems: checkList)
            
            userAuthViewModel.eventListViewModel.uploadEventItem(title: title,
                                                                 description: description,
                                                                 checkListItems: checkList)
            
            
            // Reload view model to reflect current Firebase data
            userAuthViewModel.objectWillChange.send()
            
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct addTitleSection : View {
    @Binding var title : String
    
    var body: some View {
        Section(header:
                    Text("Add a Title")
                        .font(.headline)
                        .fontWeight(.bold))
        {}
        .padding(.trailing, 300)
        .padding(.leading, 7)
        
        TextField("Add a Title", text: $title)
            .padding(.horizontal, 4)
            .frame(height: 55)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
    }
}

struct addPhotoSection : View {
    @Binding var photoItem : PhotoItem
    
    var body: some View {
        HStack {
            Section(header:
                        Text("Event Photo")
                            .font(.headline)
                            .fontWeight(.bold))
            {}
                .padding(.leading, 7)
            
            Button {
                
            } label: {
                PhotosPicker(
                    selection: $photoItem.selectedItems,
                    matching: .images
                ) {
                    Image(systemName: "plus")
                }
                .onChange(of: photoItem.selectedItems) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            photoItem.selectedImageItem = data
                        }
                    }
                }
            }
            
            Spacer()
        }
        
        ZStack {
            // Image should be a scroll view itself
            
            Image(systemName: "photo")
                .font(.system(size: 120))
                .foregroundColor(Color.accentColor)
                .scaledToFit()
                .frame(width: 395, height: 350)
            
            if let selectedImageItem = photoItem.selectedImageItem, // Unwrap
               let uiImage = UIImage(data: selectedImageItem) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 395, height: 350)
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
}

struct addDescriptionSection : View {
    @Binding var description : String
    
    var body: some View {
        HStack {
            Section(header:
                        Text("Description")
                .font(.headline)
                .fontWeight(.bold))
            {}
                .padding(.leading, 7)
            
            Spacer()
        }
                    
        ZStack {
            TextEditor(text: $description)
                .scrollContentBackground(.hidden)
                .background(Color(UIColor.secondarySystemBackground))
            Text(description)
                .background(Color(UIColor.secondarySystemBackground))
                .frame(minHeight: 40)
                .frame(maxWidth: .infinity)
                .scrollContentBackground(.hidden)
                .opacity(0)
                .padding(.leading, 7)
        }
    }
}

struct addToDoListSection : View {
    @Binding var checkList : [CheckListItemModel]
    
    var body: some View {
        // Add Task View
        VStack (alignment: .leading) {
            HStack {
                Section(header:
                            Text("Tasks")
                                .font(.headline)
                                .fontWeight(.bold))
                {}
                    .padding(.leading, 7)
                
                Button(action: {
                    
                }, label: {
                    NavigationLink(destination: AddCheckListRowView(checkList : $checkList), label: {
                        Image(systemName: "plus")
                    })
                })
                
                Spacer()
                
                Button {
                    
                } label: {
                    NavigationLink(destination:
                                    EditAddEventTaskView(checkList: $checkList),
                                   label: {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            .foregroundColor(.blue)
                    })
                }
                .padding(.trailing, 8)
            }
            .padding(.bottom, 0.8)
            
            // Display To Do List Rows
            
            ZStack {
                if !checkList.isEmpty {
                    VStack {
                        ForEach(checkList) { checkListItem in
                                    CheckListRowView(checkListItem: checkListItem)
                                        .listRowSeparator(.hidden)
                                        .padding(.leading, 7)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 40)
    }
}

struct addPhotoGrid : View {
    var body: some View {
        VStack {
            HStack {
                Section(header:
                            Text("Photos")
                                .font(.headline)
                                .fontWeight(.bold))
                {}
                .padding(.leading, 7)
                
                Spacer()
            }
            HStack {
                Text("LazyVGrid")
                    .fontWeight(.light)
                    .padding(.top, 2)
                    .padding(.leading, 7)
                
                Spacer()
            }
            
        }
    }
}


struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddEventView()
        }
        .environmentObject(EventListViewModel())
    }
}
