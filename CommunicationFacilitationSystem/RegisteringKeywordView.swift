import SwiftUI
import SwiftData

struct RegisteringKeywordView: View {
    let sampleKeywordGroups = [
        KeywordGroup(groupName: "スポーツ", keywords: [Keyword(name: "サッカー"), Keyword(name: "バスケットボール"), Keyword(name: "野球")]),
        KeywordGroup(groupName: "食べ物", keywords: [Keyword(name: "天ぷら"), Keyword(name: "寿司"), Keyword(name: "ラーメン")])
    ]
    
    @State private var selectionValues: Set<Keyword> = []
    @Environment(\.modelContext) private var modelContext
    @Query var savedKeywordGroups: [KeywordGroup]

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                Text("あなたを表すキーワードを選択してください")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                
                List(selection: $selectionValues) {
                    ForEach(sampleKeywordGroups) { group in
                        Section(header: Text(group.groupName)) {
                            ForEach(group.keywords, id: \.self) { keyword in
                                Text(keyword.name)
                                    .tag(keyword)
                                    .onTapGesture {
                                        keyword.isSelected.toggle()
                                    }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .environment(\.editMode, .constant(.active))
                .onAppear {
                    initializeSelection()
                }
                .onChange(of: selectionValues) { newSelection in
                    for keyword in newSelection {
                        print("選択されたのは \(keyword.name)")
                        keyword.isSelected.toggle()
                        
                        do {
                            modelContext.insert(keyword)

//                            try modelContext.save()
                            print("データを保存しました")
                        } catch {
                            modelContext.insert(keyword)
                            print("データを追加しました")
                        }
                    }
                }
                
                NavigationLink(destination: ModeSelectView()) {
                    Button(action: {
                        // try? modelContext.save()
                    }) {
                        Text("選択完了")
                            .fontWeight(.medium)
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                   height: 60)
                            .background(selectionValues.count != 0 ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(.infinity)
                    }
                    .padding()
                    .disabled(selectionValues.count != 0)
                }
            }
            .navigationTitle("あなたの特徴")
        }
    }
    
    private func initializeSelection() {
        // 保存されたキーワードを取得し、selectionValuesに追加
        let savedKeywords = savedKeywordGroups.flatMap { $0.keywords }
        selectionValues = Set(savedKeywords)

        // sampleKeywordGroups内の該当するキーワードのisSelectedを更新
        for groupIndex in sampleKeywordGroups.indices {
            for keywordIndex in sampleKeywordGroups[groupIndex].keywords.indices {
                if savedKeywords.contains(sampleKeywordGroups[groupIndex].keywords[keywordIndex]) {
                    sampleKeywordGroups[groupIndex].keywords[keywordIndex].isSelected = true
                    print(sampleKeywordGroups[groupIndex].keywords[keywordIndex].name)
                }
            }
        }
        
        print("sssssss")
    }
}

#Preview {
    NavigationView {
        RegisteringKeywordView()
    }
}
