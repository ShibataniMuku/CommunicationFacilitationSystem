import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationView{
            ZStack{
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Text("あなたと気が合いそうな人が表示されます。\nタップして会いに行ってみましょう")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    List() {
                        Button(action: {
                        }) {
                            HStack{
                                Text("aaaa")
                                Spacer()
                                Text("bbb")
                                    .padding(5)
                                    .background(
                                        GeometryReader { geometry in
                                            RoundedRectangle(cornerRadius: .infinity)
                                                .fill(Color.orange)
                                                .frame(width: geometry.size.width,
                                                       height: geometry.size.height)
                                        }
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button(action: {
                        }) {
                            HStack{
                                Text("aaaa")
                                Spacer()
                                Text("bbb")
                                    .padding(5)
                                    .background(
                                        GeometryReader { geometry in
                                            RoundedRectangle(cornerRadius: .infinity)
                                                .fill(Color.orange)
                                                .frame(width: geometry.size.width,
                                                       height: geometry.size.height)
                                        }
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .navigationTitle("散策中")
                    .scrollContentBackground(.hidden)
                    .environment(\.editMode, .constant(.active))
                }
            }
        }    }
}

#Preview {
    TestView()
}
