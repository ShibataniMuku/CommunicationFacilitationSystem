import SwiftUI

struct RegisteringKeywordView: View {
    let sampleKeywordGroups = [
        KeywordGroup(groupName: "スポーツ", keywords: [
            Keyword(name: "サッカー"),
            Keyword(name: "バスケットボール"),
            Keyword(name: "野球")
        ]),
        KeywordGroup(groupName: "食べ物", keywords: [
            Keyword(name: "天ぷら"),
            Keyword(name: "寿司"),
            Keyword(name: "ラーメン")
        ])
    ]
    
    @State private var selectionValues: Set<Keyword> = []
    private let userDefaultsKey = "SelectedKeywords"

    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack{
                Text("あなたを表すキーワードを選択してください")
                    .padding(.vertical)
                    .multilineTextAlignment(.center)                
                
                List(selection: $selectionValues) {
                    ForEach(sampleKeywordGroups) { group in
                        Section(header: Text(group.groupName)) {
                            ForEach(group.keywords, id: \.self) { keyword in
                                Text(keyword.name)
                                    .tag(keyword)
                            }
                        }
                    }
                }
                .environment(\.editMode, .constant(.active))
                .onAppear {
                    loadSelection()
                }
                .onChange(of: selectionValues) { _ in
                    saveSelection()
                }
                .navigationTitle("キーワード")
                .toolbarTitleDisplayMode(.inline)
            }
        }
    }

    /// ユーザーが選択したキーワードを保存
    private func saveSelection() {
        let keywordNames = selectionValues.map { $0.name } // キーワード名のみを保存
        UserDefaults.standard.set(keywordNames, forKey: userDefaultsKey)
        print("選択されたキーワードを保存しました: \(keywordNames)")
    }

    /// ユーザーが保存したキーワードの選択状態を読み込む
    private func loadSelection() {
        if let savedNames = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            let savedKeywords = sampleKeywordGroups
                .flatMap { $0.keywords }
                .filter { savedNames.contains($0.name) }
            selectionValues = Set(savedKeywords)
            print("保存された選択状態を復元しました: \(savedNames)")
        }
    }
}

#Preview {
    NavigationView {
        RegisteringKeywordView()
    }
}
