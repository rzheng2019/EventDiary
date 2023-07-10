//
//  UserAuthViewModel.swift
//  EventDiary
//
//  Created by Ricky Zheng on 2/23/23.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit


class UserAuthViewModel : ObservableObject {
    // Firebase Authorization
    @Published var eventListViewModel : EventListViewModel
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    // Allows updating the view whenever user logs out
    @Published var signedIn : Bool = false
    @Published var loginFailure : Bool = false
    @Published var signUpFailure : Bool = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    init() {
        self.eventListViewModel = EventListViewModel()
        if isSignedIn {
            fetchUserData()
        }
    }
    
    func fetchUserData() {
        // This code manages the data model within the app by grabbing data from Firebase
        guard let loginID = self.auth.currentUser?.uid else {
            print("Failed to find user: \(String(describing: self.auth.currentUser?.uid))")
            return
        }
        
        // Dispatch Group
        let group = DispatchGroup()
        
        // Entering Async Firebase Functions
        do {
            // Populate event items list rows
            self.db.collection("Users").document("\(String(describing: loginID))").collection("EventList").getDocuments { (querySnapshot, err) in
                if err != nil {
                    print("Error 2")
                    return
                }
                            
                if let eventListDocuments = querySnapshot?.documents {
                    for eventListDocument in eventListDocuments {
                        // Enter for every EventList item
                        group.enter()

                        // Grab title and description from Firestore
                        let title = eventListDocument.data()["title"] as? String ?? ""
                        let description = eventListDocument.data()["description"] as? String ?? ""

                        // Grab url for thumbnail image
                        let storageRef = Storage.storage().reference()
                        let storagePath = "\(eventListDocument.data()["url"] ?? "")"
                        let fileRef = storageRef.child(storagePath)
                        var thumbnailImage : UIImage? = nil
                        
                        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                            if error == nil && data != nil {
                                // Create UIImage for thumbnail display
                                if let thumbnail = UIImage(data: data!) {
                                    thumbnailImage = thumbnail
                                }
                            }
                            else {
                            }
                            group.leave()
                        }
                                                
    //                    Populate check list items
                        self.db.collection("Users").document("\(String(describing: loginID))").collection("EventList")
                            .document("\(eventListDocument.documentID)").collection("CheckList").getDocuments { (querySnapshot2, err) in
                                if err != nil {
                                    print("Error 3")
                                    return
                                }
                                if let checkListDocuments = querySnapshot2?.documents {
                                    var checkList : [CheckListItemModel] = []
                                    for checkListDocument in checkListDocuments {
                                        // Create CheckListItems and add to CheckList Container
                                        let checkListItem = CheckListItemModel(id: checkListDocument.documentID,task: checkListDocument.data()["task"] as? String ?? "", isCompleted: checkListDocument.data()["isCompleted"] as? Bool ?? false)
                                        checkList.append(checkListItem)
                                    }
                                    
                                    checkList.sort {
                                        // Unfinished tasks takes priority
                                        !$0.isCompleted && $1.isCompleted
                                    }
                                    group.notify(queue: .main, execute: {
                                        self.eventListViewModel.addEventItem(id: "\(eventListDocument.documentID)",
                                                                             photo: thumbnailImage,
                                                                             title: title,
                                                                             description: description,
                                                                             checkListItems: checkList)
                    
                                        self.eventListViewModel.eventItems.sort {
                                            // Alphabetical order
                                            $0.title ?? "" < $1.title ?? ""
                                        }
                                        self.signedIn = self.isSignedIn
                                    })
                                }
                            }
                    }
                    // If no event list items, just sign in and go to EmptyEventView
                    self.signedIn = self.isSignedIn
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                self?.loginFailure = true
                return
            }
            
            // Success
            DispatchQueue.main.async {
                self?.loginFailure = false
                self?.fetchUserData()
            }
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                self?.signUpFailure = true
                return
            }
            
            // Success
            DispatchQueue.main.async {
                self?.signUpFailure = false
                self?.signedIn = true
                
                // Create a new user
                let loginID = self?.auth.currentUser?.uid ?? "New User"
                
                // Create new user in Firestore "Users" collection
                self?.db.collection("Users").document(loginID).setData(["uid" : self?.auth.currentUser?.uid ?? "N/A"], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                    else {
                        print("Document successfully written!")
                    }
                }
                
                self?.db.collection("Users").document(loginID).setData(["email" : email], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                    else {
                        print("Document successfully written!")
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            // Attempt sign out
            try auth.signOut()
            
            // User has signed out
            self.signedIn = false
            
            // Clear out previous event list
            self.eventListViewModel.eventItems.removeAll()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
