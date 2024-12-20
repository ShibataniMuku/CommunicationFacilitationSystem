import SwiftUI

// KeywordGroups構造体の定義
struct KeywordGroups: Identifiable {
    let id = UUID()
    let groupName: String
    let keywords: [String]
}

// メインビュー
struct RegisteringKeywordView: View {
    let sampleKeywordGroups = [
        KeywordGroups(groupName: "スポーツ", keywords: ["サッカー", "野球", "テニス", "卓球", "バレー", "バスケットボール"]),
        KeywordGroups(groupName: "食べ物", keywords: ["ラーメン", "ハンバーガー", "寿司", "天ぷら", "うどん"]),
        KeywordGroups(groupName: "趣味", keywords: ["映画", "音楽", "漫画", "アニメ", "アウトドア"])
    ]
    
    @State private var selectionValues: Set<String> = []
//    let keywordGroups: [KeywordGroups]

    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack{
                Text("あなたを表すキーワードを選択してください")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                
                List(selection: $selectionValues) {
                    ForEach(sampleKeywordGroups) { group in
                        Section(header: Text(group.groupName)) {
                            ForEach(group.keywords, id: \.self) { keyword in
                                Text(keyword)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .environment(\.editMode, .constant(.active))
                
                NavigationLink(destination: EventPasswordView()){
                    Text("選択完了")
                        .fontWeight(.medium)
                        .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                               height: UIScreen.main.bounds.size.width / 6 * 1)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(.infinity)
                }
            }
            .padding()
            .navigationTitle("あなたの特徴")
        }
    }
}

#Preview {
    NavigationView{
        RegisteringKeywordView()
    }
}
