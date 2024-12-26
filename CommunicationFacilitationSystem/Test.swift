import SwiftUI

struct Test: View {
    @State private var count: Int = 0 // 値を監視するためのカウンタ
    @State private var isFirst: Bool = true // 条件に基づいて更新する値

    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)") // 現在のカウントを表示
            Text("isFirst: \(isFirst ? "true" : "false")") // 現在のisFirstの状態を表示
            
            // ボタンでカウントを増加
            Button("Increase Count") {
                count += 1 // カウントを増やす
                if count >= 1 { // 1以上ならば
                    isFirst = false // isFirstをfalseに変更
                }
            }
        }
        .padding()
    }
}
