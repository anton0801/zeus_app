import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var settingsRepository = SettingsRepository()
    
    var body: some View {
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
            
            Text("SETTINGS")
                .font(.custom("Coiny-Regular", size: 64))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 1)
            
            Spacer()
            
            Text("SOUND")
                .font(.custom("Coiny-Regular", size: 64))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 1)
            
            Button {
                settingsRepository.sounds = !settingsRepository.sounds
            } label: {
                HStack {
                    if settingsRepository.sounds {
                        ForEach(0..<5, id: \.self) { _ in
                            Image("slider_item")
                                .animation(.easeInOut(duration: 0.2))
                        }
                    } else {
                        Image("slider_item")
                            .opacity(0)
                    }
                }
                .frame(width: 310, height: 40)
                .background(
                    Image("slider_bg")
                        .resizable()
                        .frame(width: 310, height: 40)
                )
            }
            
            Spacer().frame(height: 42)
            
            Text("MUSIC")
                .font(.custom("Coiny-Regular", size: 64))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 1)
            
            Button {
                settingsRepository.music = !settingsRepository.music
            } label: {
                HStack {
                    if settingsRepository.music {
                        ForEach(0..<5, id: \.self) { _ in
                            Image("slider_item")
                                .animation(.easeInOut(duration: 0.2))
                        }
                    } else {
                        Image("slider_item")
                            .opacity(0)
                    }
                }
                .frame(width: 310, height: 40)
                .background(
                    Image("slider_bg")
                        .resizable()
                        .frame(width: 310, height: 40)
                )
            }
            
            Spacer()
            Spacer()
        }
        .background(
            Image("back_image2")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    SettingsView()
}
