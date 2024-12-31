import SwiftUI

struct RegisteringMyNameSetupView: View {
    @AppStorage("MyName") var name: String = ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(){
                    Text("あなたの名前を入力してください\n相手のデバイスに表示されます")
                        .padding(.vertical)
                        .multilineTextAlignment(.center)
                    
                    Form {
                        TextField("名前", text: $name)
                    }
                    .navigationTitle("ニックネーム")
                    
                    Spacer()
                        
                    NavigationLink(destination: RegisteringKeywordSetupView()) {
                        Button(action: {
                            print("ボタンが押されました")
                        }) {
                            Text("入力完了")
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                       height: 60)
                                .background(name != "" ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(.infinity)
                        }
                        .padding()
                        .disabled(name != "")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        RegisteringMyNameSetupView()
    }
}
