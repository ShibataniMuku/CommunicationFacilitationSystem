import SwiftUI

struct RegisteringKeywordSetupView: View {
    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(){
                RegisteringKeywordView()
                
                Spacer()
                
                NavigationLink(destination: ModeSelectView()) {
                    Button(action: {
                        print("aaaaaaaa")
                    }) {
                        Text("選択完了")
                            .fontWeight(.medium)
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                   height: 60)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(.infinity)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        RegisteringKeywordSetupView()
    }
}
