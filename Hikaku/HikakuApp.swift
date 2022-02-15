import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseStorage

@main
struct HikakuApp: App {
    @StateObject var viewModel = AuthenticationViewModel()
    
    init() {
        setupAuthentication()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

extension HikakuApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}

