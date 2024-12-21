import SwiftUI

struct RegisteringMyNameView: View {
    @AppStorage("MyName") var name: String = ""

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                Text("あなたの名前を入力してください\nニックネームでも構いません")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()

                Form {
                    TextField("名前", text: $name)
                }

                NavigationLink(destination: RegisteringKeywordView()) {
                    Text("入力完了")
                        .fontWeight(.medium)
                        .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                               height: UIScreen.main.bounds.size.width / 6 * 1)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(.infinity)
                }
            }
            .padding()
            .navigationTitle("あなたの名前") // ここでタイトルを設定
        }
    }
}

#Preview {
    NavigationView { // 外部でNavigationViewを使用
        RegisteringMyNameView()
    }
}
