//
//  EventBoardListView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 10/19/22.
//

import SwiftUI

struct EventListView: View {
    
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    @State var isSubview : Bool = false
    @State private var showingAlert : Bool = false
    
    var body: some View {
        ZStack {
            if userAuthViewModel.eventListViewModel.eventItems.isEmpty {
                EmptyEventView()
            }
            else {
                VStack {
                    List {
                        ForEach(Array(userAuthViewModel.eventListViewModel.eventItems.enumerated()), id: \.offset) { index, eventItem in
                            NavigationLink {
                                // Need to send current index in order to know which event to modify edited
                                EventDetailView(eventItem: eventItem, eventItemIndex: index)
                            } label: {
                                EventListRowView(eventItem: eventItem)
                            }
                        }
                        .onDelete { indexSet in
                            updateUserAuthViewModel(indexSet: indexSet, completionHandler: updateUserAuthViewModelCompletionHandler)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationBarItems(
                        leading: EditButton(),
                        trailing:
                            NavigationLink("New Event") {
                                AddEventView()
                            }
                    )
                    // Sign Out Button
                    Button(action: {
                        showingAlert = true
                    }, label: {
                        Text("Sign Out")
                            .foregroundColor(Color.red)
                            .padding(.bottom, 20)
                    })
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Are you sure you want to sign out?"),
                              primaryButton: .destructive(Text("Log Out")) {
                            userAuthViewModel.signOut()
                        },
                              secondaryButton: .cancel())
                    }
                }
            }
        }
    }
    
    let updateUserAuthViewModelCompletionHandler:(UserAuthViewModel)->Void = { userAuthViewModel in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            userAuthViewModel.objectWillChange.send()
        }
    }
    
    func updateUserAuthViewModel(indexSet: IndexSet, completionHandler:(UserAuthViewModel)->Void) {
        userAuthViewModel.eventListViewModel.deleteEventItem(indexSet: indexSet)
        
        completionHandler(userAuthViewModel)
    }
}

struct NavigationLazyView<Content: View> : View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body : Content {
        build()
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventListView()
        }
        .environmentObject(UserAuthViewModel())
    }
}

