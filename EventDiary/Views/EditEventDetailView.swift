//
//  ContentView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 10/25/22.
//

import PhotosUI
import SwiftUI

struct EditEventDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    let eventItem: EventItemModel
    let eventItemIndex: Int
    
    @State var description : String = ""
    @State var title : String = ""
    @State var photoItem : PhotoItem = PhotoItem()
    @State var thumbnail : Image = Image(systemName: "photo")
    @State var checkList : [CheckListItemModel]
    
    init(eventItem: EventItemModel, eventItemIndex: Int) {
        self._description = State(initialValue: eventItem.description ?? "")
        self._title = State(initialValue: eventItem.title ?? "")
        self.eventItem = eventItem
        self.eventItemIndex = eventItemIndex
        
        if let uiImage = eventItem.photo {
            self._thumbnail = State(initialValue: Image(uiImage: uiImage))
        }
        
        self._checkList = State(initialValue: eventItem.checkListItems)
    }
    
    let hikerBackgroundColor : UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    var photoSelected: UIImage?
    
    var body: some View {
        ScrollView {
            EditEventDetailHeader()
            
            EditEventAddTitle(title: $title)
            
            EditEventThumbnail(photoItem  : $photoItem,
                               thumbnail  : $thumbnail,
                               eventItem  : eventItem)
            
            EditEventDescription(description: $description)
            
            EditEventToDoList(eventItem: eventItem,
                              eventItemIndex: eventItemIndex,
                              checkList: $checkList)

            // Save Button
            Button(action: {
                saveButtonPressed(completionHandler: updateCheckListCompletionHandler)
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
    
    let updateCheckListCompletionHandler:(Int, UserAuthViewModel) -> Void = { eventItemIndex, userAuthViewModel in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            userAuthViewModel.eventListViewModel.updateEventListItem(eventItemIndex: eventItemIndex,
                                                                     photo: userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].photo,
                                                                     title: userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].title ?? "",
                                                                     description: userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].description ?? "",
                                                                     checkList: userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems)
            
            userAuthViewModel.objectWillChange.send()
        }
    }
    
    func saveButtonPressed(completionHandler:(Int, UserAuthViewModel)->Void) {
        // Assume there is already a image whether it be user selected or stock photo
        if let selectedImageItem = photoItem.selectedImageItem, // Unwrap
           let uiImage = UIImage(data: selectedImageItem) {
            userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].photo = uiImage
            userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].title = title
            userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].description = description
            userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems = checkList
            
            // Delete firestore EventItem's current CheckList to refresh
            userAuthViewModel.eventListViewModel.deleteCheckList(eventItemIndex: eventItemIndex)
            
            // Call firestore update function
            completionHandler(eventItemIndex, userAuthViewModel)
            
            presentationMode.wrappedValue.dismiss()
        }
        else {
            userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].title = title
            userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].description = description
            userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems = checkList

            // Delete firestore EventItem's current CheckList to refresh
            userAuthViewModel.eventListViewModel.deleteCheckList(eventItemIndex: eventItemIndex)
            
            // Call firestore update function
            completionHandler(eventItemIndex, userAuthViewModel)
            
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct EditEventDetailHeader : View {
    var body: some View {
        Section(header:
                    Text("Edit Event Details")
            .font(.system(size: 30))
            .font(.headline)
            .fontWeight(.bold))
        {}
            .padding(.trailing, 140)
            .padding(.bottom, 5)
    }
}

struct EditEventAddTitle : View {
    @Binding var title : String
    
    var body: some View {
        Section(header:
                    Text("Add a Title")
            .font(.headline)
            .fontWeight(.bold))
        {}
            .padding(.trailing, 300)
        
        TextField(title, text: $title)
            .padding(.horizontal, 4)
            .frame(height: 55)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
    }
}

struct EditEventThumbnail : View {
    @Binding var photoItem: PhotoItem
    @Binding var thumbnail: Image
    
    let eventItem: EventItemModel
    
    var body: some View {
        HStack {
            Section(header:
                        Text("Event Photo")
                .font(.headline)
                .fontWeight(.bold))
            {}
            
            Button {
                
            } label: {
                PhotosPicker(
                    selection: $photoItem.selectedItems,
                    matching: .images
                ) {
                    Image(systemName: "plus")
                        .padding(.trailing, 265)
                }
                .onChange(of: photoItem.selectedItems) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            photoItem.selectedImageItem = data
                            thumbnail = Image(systemName: "")
                                            .resizable()
                        }
                    }
                }
            }
        }
        
        ZStack {
            // Existing photo gets set to blank background again
            
            if eventItem.photo != nil {
                Rectangle()
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                    .frame(width: 395, height: 350)
                thumbnail
                    .resizable()
                    .scaledToFit()
                    .frame(width: 395, height: 350)
                
            }
            else {
                Rectangle()
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                    .frame(width: 395, height: 350)
                
                Text("No Image Selected")
                    .foregroundColor(.secondary)
                    .opacity(0.9)
                    .italic()
                
            }
            
            // New Selected Photo
            // Make the photo selected change states when a new photo is selected
            if let selectedImageItem = photoItem.selectedImageItem, // Unwrap
               let uiImage = UIImage(data: selectedImageItem) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 395, height: 350)
            }
        }
        .frame(width: 395, height: 350)
    }
}

struct EditEventDescription : View {
    @Binding var description : String
    
    var body: some View {
        Section(header:
                    Text("Description")
            .font(.headline)
            .fontWeight(.bold))
        {}
            .padding(.trailing, 295)
        
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
        }
    }
}

struct EditEventPhotoGrid : View {
    var body: some View {
        Section(header:
                    Text("Photos")
            .font(.headline)
            .fontWeight(.bold)
            .padding(.trailing, 331))
        {
            Text("LazyVGrid")
                .fontWeight(.light)
                .padding(.trailing, 310)
                .padding(.vertical, 20)
        }
    }
}

struct EditEventToDoList : View {
    let eventItem: EventItemModel
    let eventItemIndex: Int
    
    @Binding var checkList : [CheckListItemModel]

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Section(header:
                            Text("To Do List")
                    .font(.headline)
                    .fontWeight(.bold))
                {}
                    .padding(.leading, 4)
                
                Button {
                    
                } label: {
                    NavigationLink(destination:
                                    AppendCheckListRowView(
                                        checkList: $checkList,
                                        eventItemIndex: eventItemIndex),
                                   label: {
                        Image(systemName: "plus")
                    })
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    NavigationLink(destination:
                                    EditEventTaskView(
                                        checkList: $checkList,
                                        eventItem: eventItem,
                                        eventItemIndex: eventItemIndex),
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
                // Check if preview checklist is empty, if so, show existing event item checklist
                if checkList.isEmpty {
                    if eventItem.checkListItems.isEmpty {
                        VStack {
                            Text("There are no tasks currently")
                                .multilineTextAlignment(.leading)
                                .fontWeight(.light)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 7)
                                .opacity(0.3)
                                .italic()
                            
                            HStack {
                                Text("Tap  ")
                                    .multilineTextAlignment(.leading)
                                    .fontWeight(.light)
                                    .padding(.leading, 7)
                                    .opacity(0.3)
                                    .italic()
                                
                                Image(systemName: "plus")
                                    .foregroundColor(.blue)
                                    .opacity(0.3)
                                
                                Text("to add new tasks")
                                    .multilineTextAlignment(.leading)
                                    .fontWeight(.light)
                                    .padding(.leading, 7)
                                    .opacity(0.3)
                                    .italic()
                                Spacer()
                            }

                            
                            HStack {
                                Text("Tap  ")
                                    .multilineTextAlignment(.leading)
                                    .fontWeight(.light)
                                    .padding(.leading, 7)
                                    .opacity(0.3)
                                    .italic()
                                
                                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                    .foregroundColor(.blue)
                                    .opacity(0.3)
                                
                                Text("to modify tasks")
                                    .multilineTextAlignment(.leading)
                                    .fontWeight(.light)
                                    .padding(.leading, 7)
                                    .opacity(0.3)
                                    .italic()
                                Spacer()
                            }
                            .padding(.bottom, 5)
                        }
                    }
                }
                else {
                    VStack {
                        ForEach (checkList) { checkListItem in
                            CheckListRowView(checkListItem: checkListItem)
                                .listRowSeparator(.hidden)
                                .padding(.leading, 7)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 10)
    }
}

struct EditEventDetailView_Previews: PreviewProvider {
    
    static var item = EventItemModel(photo: nil,
                                     title: "Task 1",
                                     description: "Working on Task 1")
    static var previews: some View {
        NavigationView {
            EditEventDetailView(eventItem: item, eventItemIndex: 1)
        }
        .environmentObject(EventListViewModel())
    }
}
