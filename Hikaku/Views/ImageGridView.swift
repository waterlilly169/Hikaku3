import Foundation
import SwiftUI
@available(iOS 14.0, *)
struct GridView: View {
//    var item: Todo
    
    @Binding var item: Todo // Make this a @Binding so it reacts to the changes.
    @ObservedObject var model: ApiModel
//    @ObservedObject var model = ApiModel()
    @State var newImage = ""
    @State var loc = ""
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    
    var body: some View {
        NavigationView {
            var posts = item.styleboardimages
            var nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]
           
            VStack(alignment: .leading){
                Text(item.styleboardname)
                        GeometryReader{ geo in
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 3 ){
                                ForEach(posts.sorted(by: <), id: \.key) { key, value in
                                    if #available(iOS 15.0, *) {
                                        AsyncImage(url: URL(string: value), transaction: Transaction(animation: .spring())) { phase in
                                            switch phase {
                                            case .empty:
                                                Image(systemName: "\(key).circle")
                                                    .resizable()
                                                    .aspectRatio(0.68, contentMode: .fit)
//                                                Color.purple.opacity(0.1)
                                         
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                         
                                            case .failure(_):
                                                Image(systemName: "exclamationmark.icloud")
                                                    .resizable()
                                                    .scaledToFit()
                                         
                                            @unknown default:
                                                Image(systemName: "exclamationmark.icloud")
                                                
                                            }
                                        }
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(20)
                                    } else {
//                                         Fallback on earlier versions
                                    }

                                }
                            }
                        }
                VStack(spacing: 5) {
                    Text("Add Image To Styleboard")
                    
                    Button (action: {
                        shouldShowImagePicker.toggle()}
                    , label: { Text("Import Image From Camera Roll")})
                    
                    TextField("location", text: $loc)
                    Button(action: {
                            self.persistImageToStorage()
                            model.getData()
    //                        model.getImageData(id: item.id)
                        }, label: {
                            Image(systemName: "pencil")
                        })
                        .buttonStyle(BorderlessButtonStyle())
                }

            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                        .ignoresSafeArea()
                }
//        let posts = Array(item.styleboardimages)
    }
  private func persistImageToStorage() {
    guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
    let uuid = UUID().uuidString
    let ref = FirebaseManager.shared.storage.reference(withPath: uuid)
    guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
    print(item.styleboardimages)
    ref.putData(imageData, metadata: nil) { metadata, err in
        if let err = err {
            print("Failed to push image to Storage: \(err)")
            return
        }
        
        ref.downloadURL { url, err in
            if let err = err {
                print("Failed to retrieve downloadURL: \(err)")
                return
            }
            
            print("Successfully stored image with url: \(url?.absoluteString ?? "")")
            print(url?.absoluteString ?? "")
            
            guard let url = url else { return }
            self.model.updateData(did: item.id, loc: loc, newImage: url)
        }
    }
}
    
}

@available(iOS 14.0, *)
struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        GridView(item: )
//        NavigationView {
//            GridView(item: model.list[1])
//                }
    }
}
