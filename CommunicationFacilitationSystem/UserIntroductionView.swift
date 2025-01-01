import SwiftUI

struct UserIntroductionView: View {
    var user: User = User(name: "太郎", selfIntroduction: "よろしく", mettedDay: Date.now, channel: "吉野研究室")
    
    var body: some View {
        Circle()
            .frame(width: 160)
            .padding()
        
        List{
            Text(user.name)
            Text(user.selfIntroduction)
//                    Text(user.mettedDay)
            Text(user.channel)
        }
        .navigationTitle(user.name)
    }
}

#Preview {
    UserIntroductionView()
}
