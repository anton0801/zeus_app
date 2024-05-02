import SwiftUI
import SpriteKit

struct AssimetricGameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var levelsRepository: LevelsRepository
    
    var level: LevelItem
    @State var levelState: LevelItem?
    
    @State var isGamePaused = false
    @State var isGameWin = false
    @State var isGameLose = false
    
    @State var assimerticGameScene: AssimetricGameScene = AssimetricGameScene()
    
    var body: some View {
        ZStack {
            SpriteView(scene: assimerticGameScene)
                .ignoresSafeArea()
                .onAppear {
                    assimerticGameScene.level = level
                    assimerticGameScene.levelsRepository = levelsRepository
                }
            if isGamePaused {
                VStack {
                    Spacer().frame(height: 50)
                    
                    Text("PAUSE")
                        .font(.custom("Coiny-Regular", size: 64))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("GAME PAUSED")
                        .font(.custom("Coiny-Regular", size: 42))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 80)
                    
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("home_btn")
                        }
                        Button {
                            isGamePaused = false
                            assimerticGameScene.continuePlay()
                        } label: {
                            Image("play_btn2")
                        }
                        Button {
                            isGamePaused = false
                            assimerticGameScene = assimerticGameScene.restartGame()
                        } label: {
                            Image("restart_btn")
                        }
                    }
                    
                    Spacer()
                }
                .background(
                    Image("back_image")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .ignoresSafeArea()
                )
            } else if isGameWin {
                VStack {
                    Spacer().frame(height: 50)
                    
                    Text("YOU WIN!")
                        .font(.custom("Coiny-Regular", size: 64))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("CONGRATULATIONS")
                        .font(.custom("Coiny-Regular", size: 32))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 80)
                    
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("home_btn")
                        }
                        Button {
                            isGameWin = false
                            assimerticGameScene.restartGame()
                        } label: {
                            Image("restart_btn")
                        }
                        Button {
                            isGameWin = false
                            if levelsRepository.nextLevelIsAvailable(currentLevel: levelState!.levelNum) {
                                levelState = levelsRepository.getLevelItemByNum(neededLevel: levelState!.levelNum + 1)!
                                assimerticGameScene.level = levelState
                                assimerticGameScene.restartGame()
                            }
                        } label: {
                            Image("arrow_forward2")
                        }
                    }
                    
                    Spacer()
                }
                .background(
                    Image("back_image")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .ignoresSafeArea()
                )
            } else if isGameLose {
                VStack {
                    Spacer().frame(height: 50)
                    
                    Text("YOU LOSE!")
                        .font(.custom("Coiny-Regular", size: 64))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("TRY AGAIN!")
                        .font(.custom("Coiny-Regular", size: 42))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 80)
                    
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("home_btn")
                        }
                        Button {
                            isGameWin = false
                            assimerticGameScene.restartGame()
                        } label: {
                            Image("restart_btn")
                        }
                    }
                    
                    Spacer()
                }
                .background(
                    Image("back_image")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .ignoresSafeArea()
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_PAUSE"))) { _ in
            isGamePaused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_LOSE"))) { _ in
            isGameLose = true
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_WIN"))) { _ in
            isGameWin = true
        }
        .preferredColorScheme(.dark)
        .onAppear {
            levelState = level
        }
    }
}

#Preview {
    AssimetricGameView(level: LevelItem(id: "level_1", levelNum: 1, levelStructure: [[1, 1, 1, 0], [0, 1, 1, 1]]))
        .environmentObject(LevelsRepository())
}
