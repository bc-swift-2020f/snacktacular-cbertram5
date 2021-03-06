//
//  Review.swift
//  Snacktacular
//
//  Created by Chris Bertram on 11/10/20.
//

import Foundation
import Firebase

class Review {
    var title: String
    var text: String
    var rating: Int
    var reviewUserID: String
    var date: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["title": title, "text": text, "rating": rating, "reviewUserID": reviewUserID, "date": timeIntervalDate]
    }
    
    init(title: String, text: String, rating: Int, reviewUserID: String, date: Date, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewUserID = reviewUserID
        self.date = date
        self.documentID = documentID
    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        self.init(title: "", text: "", rating: 0, reviewUserID: reviewUserID, date: Date(), documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let rating = dictionary["rating"] as! Int? ?? 0
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let reviewUserID = dictionary["reviewUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        
        
        self.init(title: title, text: text, rating: rating, reviewUserID: reviewUserID, date: date, documentID: documentID)
    }


    func saveData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, well have an ID, otherwise .adddocument will create one
        if self.documentID == "" { // create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave){ (error) in
                guard error == nil else {
                    print("😡 ERROR: adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("🥳 added document: \(self.documentID) to spot: \(spot.documentID)") // it WORKED!
                completion(true)
            }
        } else { // else save to the existing documentID w/ .setData
            let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("😡 ERROR: updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("🥳 updated document: \(self.documentID) in spot: \(spot.documentID)") // it WORKED!
                completion(true)
            }
        }
    }
}
