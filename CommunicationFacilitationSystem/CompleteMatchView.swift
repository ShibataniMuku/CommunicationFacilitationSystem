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
                
                NavigationLink(destination: RegisteringKeywordView()) {
                    Button{
                        
                    } label: {
                        Text("ホームへ戻る")
                            .fontWeight(.medium)
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                   height: UIScreen.main.bounds.size.width / 6 * 1)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(.infinity)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    CompleteMatchView()
}
