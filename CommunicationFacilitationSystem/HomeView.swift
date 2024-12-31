import SwiftUI

struct HomeView: View {
    @State var selectionTab = 1
    
    var body: some View {
        TabView(selection: $selectionTab){
            ModeSelectView()
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("プロフィール", systemImage: "person")
                }
                .tag(1)
        }
    }
}

#Preview {
    HomeView()
}
