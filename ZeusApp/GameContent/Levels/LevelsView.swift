import SwiftUI

struct LevelsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var levelsRepository = LevelsRepository()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("home_btn")
                    }
                    
                    Spacer()
                }
                .padding()
                
                Text("PLAY")
                    .font(.custom("Coiny-Regular", size: 64))
                    .foregroundColor(.white)
                
                LazyVGrid(columns: [
                    GridItem(.fixed(80)),
                    GridItem(.fixed(80)),
                    GridItem(.fixed(80)),
                    GridItem(.fixed(80))
                ], spacing: 8) {
                    ForEach(levelsRepository.allLevels, id: \.id) { levelItem in
                        VStack {
                            if levelsRepository.unlockedLevelIds.contains(levelItem.id) {
                                NavigationLink(destination: AssimetricGameView(level: levelItem)
                                    .navigationBarBackButtonHidden(true)
                                    .environmentObject(levelsRepository)) {
                                    Text("\(levelItem.levelNum)")
                                        .font(.custom("Coiny-Regular", size: 46))
                                        .foregroundColor(.white)
                                }
                            } else {
                                Image("lock")
                            }
                        }
                        .background(
                            Image("level_item_bg")
                        )
                        .padding(.top, 24)
                    }
                }
                .padding([.top, .leading, .trailing], 42)
                
                Spacer()
            }
            .background(
                Image("back_image2")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onAppear {
                levelsRepository.obtainLevelsUnlocked()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LevelsView()
}
