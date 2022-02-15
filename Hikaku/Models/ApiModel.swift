import Foundation
import FirebaseFirestore
import Firebase
import GoogleSignIn
import SwiftUI
import FirebaseStorage


class ApiModel: ObservableObject {
    
    @Published var list = [Todo]()
    @Published var griddata = [String]()
     
    
    func updateData(did: String, loc: String, newImage: URL) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Set the data to update
        db.collection("users").document(did).updateData(["styleboardimages.\(loc)": newImage.absoluteString]) {
            error in

            if error == nil {
                // Get the new data
                self.getData()
            }
        }
    }
    func deleteData(todoToDelete: Todo) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Specify the document to delete
        db.collection("users").document(todoToDelete.id).delete { error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                // Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    // Remove the todo that was just deleted
                    self.list.removeAll { todo in
                        
                        // Check for the todo to remove
                        return todo.id == todoToDelete.id
                    }
                }
                
                
            }
        }
        
    }
    
    func addData(email: String, styleboardname: String) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        
        // Add a document to a collection
        db.collection("users").addDocument(data: ["email":email, "styleboardname": styleboardname, "styleboardimages": ["1": "", "2": "", "3": "", "4": "", "5": "", "6": "", "7": "", "8": "", "9": ""] ] ) { error in
//      
            // Check for errors
            if error == nil {
                // No errors
                
                // Call get data to retrieve latest data
                self.getData()
            }
            else {
                // Handle the error
            }
        }
    }
    
    func getData() {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("users").getDocuments { snapshot, error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        // Get all the documents and create Todos
                        self.list = snapshot.documents.map { d in
                            
                            // Create a Todo item for each document returned
                            return Todo(id: d.documentID,
                                        email: d["email"] as? String ?? "",
                                        styleboardname: d["styleboardname"] as? String ?? "",
                                        styleboardimages: d["styleboardimages"] as? [String:String] ?? [:])
                        }
                    }
                    
                    
                }
            }
            else {
                // Handle the error
            }
        }
    }
    func getDataStyle(id: String) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("users").document("styleboardimages")
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
              print("Current data: \(data)")
                    
                }
            }
    }

