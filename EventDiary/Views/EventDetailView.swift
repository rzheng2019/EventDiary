//
//  EventDetailView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 10/25/22.
//

import SwiftUI

struct EventDetailView: View {
    
    var eventItem: EventItemModel
    var eventItemIndex: Int
    
    var body: some View {
        ScrollView {
            if let thumbnail = eventItem.photo,
               let thumbnailTitle = eventItem.title,
               let thumbnailDescription = eventItem.description {
                EventDetailsHeader(eventItem       : eventItem,
                                   eventItemIndex  : eventItemIndex,
                                   thumbnailTitle  : thumbnailTitle)
                
                EventDetailsImage(thumbnail: thumbnail)
                
                EventDetailsDescription(thumbnailDescription: thumbnailDescription)
                
                EventDetailsToDoList(eventItem: eventItem, eventItemIndex: eventItemIndex)
            }
            else {
                EventDetailIncompletePage(eventItem: eventItem, eventItemIndex: eventItemIndex)
            }
        }
    }
}

struct EventDetailsHeader : View {
    let eventItem: EventItemModel
    let eventItemIndex: Int
    let thumbnailTitle : String
    
    var body: some View {
        HStack {
            Section(header:
                        Text(thumbnailTitle)
                .font(.system(size: 30))
                .font(.headline)
                .fontWeight(.bold))
            {}
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.bottom, 5)
            
            // Need to pass in index of current eventItem in order to go and modify it
            NavigationLink {
                EditEventDetailView(eventItem: eventItem, eventItemIndex: eventItemIndex)
            } label: {
                Text("Edit")
                    .padding(.trailing, 10)
            }
        }
    }
}

struct EventDetailsImage : View {
    var thumbnail : UIImage? = nil
    
    var body: some View {
        if let uiImage = thumbnail {
            if uiImage == UIImage(systemName: "photo") {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                        .frame(width: 395, height: 350)
                    
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(Color.blue)
                        .frame(width: 120, height: 100)
                }
            }
            else {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 395, height: 350)
            }
        }
    }
}

struct EventDetailsDescription : View {
    let thumbnailDescription : String
    
    var body: some View {
        Section(header:
                    Text("Description")
            .font(.headline)
            .fontWeight(.bold))
        {}
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 7)
            .padding(.bottom, 0.5)
        
        VStack (alignment: .leading) {
            if thumbnailDescription == "" {
                Text("No Description")
                    .multilineTextAlignment(.leading)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 7)
                    .background(Color.black)
                    .opacity(0.2)
                    .padding(.bottom, 5)
            }
            else {
                Text(thumbnailDescription)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 7)
                    .padding(.bottom, 5)
            }
        }
    }
}

struct EventDetailsToDoList : View {
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    var eventItem : EventItemModel
    var eventItemIndex : Int
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Section(header:
                            Text("To Do List")
                    .font(.headline)
                    .fontWeight(.bold))
                {}
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 7)
                    .padding(.bottom, 0.5)
            }
            .padding(.bottom, 0.8)
            
            // Display To Do List Rows
            
            ZStack {
                if eventItem.checkListItems.isEmpty {
                    Text("No Tasks in To Do List")
                        .multilineTextAlignment(.leading)
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 7)
                        .background(Color.black)
                        .opacity(0.2)
                        .padding(.bottom, 5)
                }
                else {
                    VStack {
                            if !eventItem.checkListItems.isEmpty {
                                ForEach (Array(eventItem.checkListItems.enumerated()), id: \.element.id) { index, checkListItem in
                                    CheckListRowView(checkListItem: checkListItem)
                                        .listRowSeparator(.hidden)
                                        .padding(.leading, 7)
                                        .onTapGesture {
                                            userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems[index] =
                                            userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems[index].updateCompletion()
                                            
                                            let taskString : String = userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems[index].task
                                            let taskStatus : Bool = userAuthViewModel.eventListViewModel.eventItems[eventItemIndex].checkListItems[index].isCompleted
                                            
                                            userAuthViewModel.eventListViewModel.updateCheckListItem(eventItemIndex: eventItemIndex,
                                                                                                     checkListitemIndex: index,
                                                                                                     task: taskString,
                                                                                                     isCompleted: taskStatus)
                                            // Need to manually tell listener to update check list
                                            userAuthViewModel.objectWillChange.send()
                                        }
                                }
                            }
//                        }
                    }
                }
            }
        }
        .padding(.bottom, 10)
    }
}

struct EventDetailsPhotoGrid : View {
    var body: some View {
        // LazyVGrid
        
        Section(header:
                    Text("Photos")
            .font(.headline)
            .fontWeight(.bold))
        {}
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 7)
            .padding(.bottom, 0.5)
        
        VStack {
            Text("LazyVGrid")
                .multilineTextAlignment(.leading)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 7)
                .background(Color.black)
                .opacity(0.2)
                .padding(.bottom, 5)
        }
    }
}

struct EventDetailIncompletePage : View {
    var eventItem: EventItemModel
    var eventItemIndex: Int
    
    var body: some View {
        EventDetailsHeader(eventItem: eventItem,
                           eventItemIndex: eventItemIndex,
                           thumbnailTitle: eventItem.title)
        
        Image(systemName: "photo")
            .scaledToFit()
            .font(.system(size: 120))
            .foregroundColor(Color.accentColor)
            .frame(width: 395, height: 350)
            .background(Color.black)
            .opacity(0.2)
        
        EventDetailsDescription(thumbnailDescription: eventItem.description)

        EventDetailsToDoList(eventItem: eventItem,
                             eventItemIndex: eventItemIndex)
                                        .padding(.bottom, 1)
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var item = EventItemModel(photo: UIImage(systemName: ""),
                                     title: "",
                                     description: "")
    
    static var previews: some View {
        NavigationView {
            EventDetailView(eventItem: item, eventItemIndex: 1)
        }
        .environmentObject(UserAuthViewModel())
    }
}
