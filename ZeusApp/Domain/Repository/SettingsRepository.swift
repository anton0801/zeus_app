import Foundation

class SettingsRepository: ObservableObject {
    
    @Published var sounds = UserDefaults.standard.bool(forKey: "sounds_is_on") {
        didSet {
            UserDefaults.standard.set(sounds, forKey: "sounds_is_on")
        }
    }
    
    @Published var music = UserDefaults.standard.bool(forKey: "music_is_on") {
        didSet {
            UserDefaults.standard.set(music, forKey: "music_is_on")
        }
    }
    
}
