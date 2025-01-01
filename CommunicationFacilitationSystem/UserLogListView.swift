import SwiftUI

struct UserLogListView: View {
    var users: [User] = [
        User(name: "太郎", selfIntroduction: "よろしく", mettedDay: Date.now, channel: "吉野研究室")
    ]
    
    var body: some View {
        NavigationView{
            List{
                ForEach(users, id: \.id){ user in
                    NavigationLink(destination: UserIntroductionView()){
                        Text(user.name)
                    }
                }
            }
            .navigationTitle("これまでの出会い")
        }
    }
}

#Preview {
    UserLogListView()
}
