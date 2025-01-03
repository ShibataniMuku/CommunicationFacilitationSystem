import SwiftUI

struct CompleteMatchView: View {
    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(){
                Text("出会いました")
                    .font(.largeTitle)
                    .bold()
                    .padding(.vertical)
                Text("出会うことができました。")
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                Spacer()
                
                NavigationLink(destination: ModeSelectView()) {
                    Text("ホームへ戻る")
                        .fontWeight(.medium)
                        .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                               height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(.infinity)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CompleteMatchView()
}
