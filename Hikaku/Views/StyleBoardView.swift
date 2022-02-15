import SwiftUI
import Firebase
import GoogleSignIn

struct StyleBoardView: View {
    
    
    @State private var showingSheet = false
//    @StateObject var model = ApiModel()
    @ObservedObject var model = ApiModel()
    @State var styleboardname = ""

    let userEmail = Auth.auth().currentUser?.email
    
    var body: some View {
        NavigationView {
            VStack {
                Text("               Select Style Board               ")
//                    .padding(.top, -65)
                    .modifier(customViewModifier(roundedCornes: 6, startColor: .pink, endColor: .purple, textColor: .white))
                    .frame(width: 700, height: 30)
                  
                List ($model.list) {$item in
                    Button(item.styleboardname) {
                                showingSheet.toggle()
                            }
                            .sheet(isPresented: $showingSheet) {
                                GridView(item: $item, model: model)
                            }
                    
                    Button(action: {model.deleteData(todoToDelete: item)}, label: {Image(systemName: "trash")
                    })
                    
                }
                    .padding(.top, 20)
                    
                VStack(spacing: 5) {
                    Text("Create A New Style Board")
                    TextField("Style Board Name", text: $styleboardname)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 325, height: 50)
                    
                    Button(action: {
                        model.addData(email:userEmail!, styleboardname: styleboardname)
                        styleboardname = ""

                    }, label: {
                        Text("Add Style Board")
                            .modifier(customViewModifier(roundedCornes: 6, startColor: .purple, endColor: .orange, textColor: .white))
                          
                    })

                }
                
            }
        }
        .padding(.bottom, 5)
        .padding(.top, -120)
    }

    init() {
        model.getData()
    }
}

struct StyleBoardView_Previews: PreviewProvider {
    static var previews: some View {
        StyleBoardView()
    }
}
