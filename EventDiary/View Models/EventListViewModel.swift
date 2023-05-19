//
//  EventListViewModel.swift
//  EventDiary
//
//  Created by Ricky Zheng on 10/19/22.
//

import PhotosUI
import Firebase
import FirebaseAuth
import Foundation
import FirebaseStorage

class EventListViewModel: ObservableObject {
    // Firebase
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    // Event Item Data
    @Published var eventItems: [EventItemModel] = []
    
    let eventItemKey: String = "event_items_list"
        
    // Set Functions
    
    // Can make this function add to the checklist
    func addEventItem(id: String = UUID().uuidString, photo: UIImage? = nil, title: String, description: String, checkListItems: [CheckListItemModel] = []) {
        let newEventItem = EventItemModel(id: id, photo: photo, title: title, description: description, checkListItems: checkListItems)
        eventItems.append(newEventItem)
    }
    
    func uploadEventItem(photo: UIImage? = nil, title: String, description: String, checkListItems: [CheckListItemModel] = []) {
        // Upload event item to Firestore
        db.collection("Users").document("\(auth.currentUser?.uid ?? "")").collection("EventList").document("\(eventItems.last?.id ?? "")")
            .setData(["title" : title, "description" : description, "url" : ""])
        
        for (index, row) in checkListItems.enumerated() {
            db.collection("Users").document("\(String(describing: auth.currentUser?.uid ?? ""))").collection("EventList").document("\(eventItems.last?.id ?? "")").collection("CheckList").document("\(eventItems.last?.checkListItems[index].id ?? "")")
                .setData(["isCompleted" : row.isCompleted, "task" : row.task], merge: true)
        }
        
        uploadThumbnail(photo: photo)
    }
    
    func uploadThumbnail(eventItemIndex : Int? = nil, photo: UIImage? = nil) {
        if eventItemIndex != nil {
            let storageRef = Storage.storage().reference()
            let storagePath = "Users/\(String(describing: self.auth.currentUser?.uid ?? ""))/EventList/\(eventItems[eventItemIndex!].id)/thumbnail.jpg"
            if let photoData = photo {
                if let photoDataJPEG = photoData.jpegData(compressionQuality: 0.8) {
                    storageRef.child(storagePath).delete { error in
                        if let error = error {
                            print("[uploadThumbnail] Error: \(error)")
                        }
                    }
                    storageRef.child(storagePath).putData(photoDataJPEG, metadata: nil) { (newMetadata, error) in
                        if error != nil {
                            return
                        }
                        
                        self.db.collection("Users").document("\(self.auth.currentUser?.uid ?? "")").collection("EventList").document("\(self.eventItems[eventItemIndex!].id)").setData(["url" : storagePath], merge: true)
                    }
                }
            }
        }
        else {
            let storageRef = Storage.storage().reference()
            let storagePath = "Users/\(String(describing: self.auth.currentUser?.uid ?? ""))/EventList/\(String(describing: self.eventItems.last?.id ?? ""))/thumbnail.jpg"
            
            if let photoData = photo {
                if let photoDataJPEG = photoData.jpegData(compressionQuality: 0.8) {
                    storageRef.child(storagePath).delete { error in
                        if let error = error {
                            print("[uploadThumbnail] Error: \(error)")
                        }
                    }
                    storageRef.child(storagePath).putData(photoDataJPEG, metadata: nil) { (newMetadata, error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                            return
                        }
                        
                        self.db.collection("Users").document("\(self.auth.currentUser?.uid ?? "")").collection("EventList").document("\(self.eventItems.last?.id ?? "")").setData(["url" : storagePath], merge: true)
                    }
                }
            }
        }
    }
    
    func deleteEventItem(indexSet: IndexSet) {
        for index in indexSet {
            // Delete thumbnail from Firebase storage
            let storageRef = Storage.storage().reference()
            let storagePath = "Users/\(String(describing: self.auth.currentUser?.uid ?? ""))/EventList/\(eventItems[index].id)/thumbnail.jpg"
            storageRef.child(storagePath).delete { error in
                if let error = error {
                    print("[uploadThumbnail] Error: \(error)")
                }
            }
            
            // Delete check list documents individually
            db.collection("Users").document("\(String(describing: auth.currentUser?.uid ?? ""))").collection("EventList").document("\(eventItems[index].id)").collection("CheckList").getDocuments { (querySnapshot, err) in
                if err != nil {
                    print("[deletedEventItem] Error")
                    return
                }
                
                if let checkListDocuments = querySnapshot?.documents {
                    for checkListDocument in checkListDocuments {
                        self.db.collection("Users").document("\(String(describing: self.auth.currentUser?.uid ?? ""))").collection("EventList").document("\(self.eventItems[index].id)").collection("CheckList").document("\(checkListDocument.documentID)").delete()
                    }
                }
                self.db.collection("Users").document("\(String(describing: self.auth.currentUser?.uid ?? ""))").collection("EventList").document("\(self.eventItems[index].id)").delete()
                self.eventItems.remove(atOffsets: indexSet)
                }
        }
    }
    
    func updateEventListItem(eventItemIndex : Int, photo : UIImage? = nil, title : String, description : String, checkList : [CheckListItemModel]) {
        // Update EventItem title and description
        db.collection("Users").document("\(String(describing: auth.currentUser?.uid ?? ""))").collection("EventList").document("\(eventItems[eventItemIndex].id)").updateData(["title" : title, "description" : description])
        
        // Add new image to into storage and set url to that image
        uploadThumbnail(eventItemIndex: eventItemIndex, photo: photo)
        
        // Update EventItem's CheckList
        updateCheckList(eventItemIndex: eventItemIndex, checkList: checkList)
    }
    
    func deleteCheckList(eventItemIndex : Int) {
        // Delete existing CheckList in firestore
        db.collection("Users").document("\(String(describing: auth.currentUser?.uid ?? ""))").collection("EventList").document("\(eventItems[eventItemIndex].id)").collection("CheckList").getDocuments { (querySnapshot, err) in
            if err != nil {
                print("[updateCheckList] Error")
                return
            }

            if let checkListDocuments = querySnapshot?.documents {
                for checkListDocument in checkListDocuments {
                    self.db.collection("Users").document("\(String(describing: self.auth.currentUser?.uid ?? ""))").collection("EventList").document("\(self.eventItems[eventItemIndex].id)").collection("CheckList").document("\(checkListDocument.documentID)").delete()
                }
            }
        }
    }
    
    func updateCheckList(eventItemIndex : Int, checkList : [CheckListItemModel]) {
        // Set CheckList data in Firestore
        for (index, row) in checkList.enumerated() {
            db.collection("Users").document("\(String(describing: auth.currentUser?.uid ?? ""))").collection("EventList").document("\(eventItems[eventItemIndex].id)").collection("CheckList").document("\(eventItems[eventItemIndex].checkListItems[index].id)").setData(["isCompleted" : row.isCompleted, "task" : row.task])
        }
    }
    
    func updateCheckListItem(eventItemIndex : Int, checkListitemIndex : Int, task : String, isCompleted : Bool) {
        db.collection("Users").document("\(String(describing: auth.currentUser?.uid ?? ""))").collection("EventList").document("\(eventItems[eventItemIndex].id)").collection("CheckList").document("\(eventItems[eventItemIndex].checkListItems[checkListitemIndex].id)").updateData(["isCompleted" : isCompleted, "task" : task])
    }
    
    func moveEventItem(from: IndexSet, to: Int) {
        eventItems.move(fromOffsets: from, toOffset: to)
    }
}
