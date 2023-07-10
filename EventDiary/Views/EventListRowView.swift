//
//  EventListRowView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 10/19/22.
//

import SwiftUI

struct EventListRowView: View {
    let eventItem: EventItemModel
        
    var body: some View {
            HStack {
                VStack {
                    Text("")
                        .lineLimit(2)
                        .fontWeight(.bold)
                        .padding(.leading, -1)
                }
                
                // Placeholder Image
                if let thumbnail = eventItem.photo {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 120)
                }
                else {
                    ZStack {
                        Rectangle()
                            .frame(width: 150, height: 120)
                            .background(Color.black)
                            .opacity(0.1)
                            .foregroundColor(Color.white)
                        Text("No Image")
                            .foregroundColor(.secondary)
                            .opacity(0.9)
                            .italic()
                    }
                }
                
                VStack (alignment: .leading) {
                    if eventItem.title == "" {
                        Text("No Title")
                            .font(.headline)
                            .lineLimit(2)
                            .fontWeight(.bold)
                    }
                    else {
                        Text(eventItem.title ?? "")
                            .font(.headline)
                            .lineLimit(2)
                            .fontWeight(.bold)
                    }
                    
                    if eventItem.description == "" {
                        Text("No description")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    else {
                        Text(eventItem.description ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                Spacer()
            }
    }
}

struct EventListRowView_Previews: PreviewProvider {
    
    static var item = EventItemModel(photo: UIImage(systemName: "arrow.counterclockwse"),
                                     title: "",
                                     description: "")
    
    static var previews: some View {
        EventListRowView(eventItem: item)
    }
}
