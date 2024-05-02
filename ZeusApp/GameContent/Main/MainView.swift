import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("zeus")
                
                NavigationLink(destination: LevelsView()
                    .navigationBarBackButtonHidden(true)) {
                        Image("play_btn")
                            .offset(y: -10)
                    }
                
                Button {
                    exit(0)
                } label: {
                    Image("quit_btn")
                        .padding(.top)
                }
                .offset(y: -10)
                
                NavigationLink(destination: SettingsView()
                    .navigationBarBackButtonHidden(true)) {
                        Image("settings_btn")
                            .padding(.top)
                            .offset(y: -10)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MainView()
}
