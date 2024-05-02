import Foundation

class LevelsRepository: ObservableObject {
    
    var allLevels = [
        LevelItem(id: "level_1", levelNum: 1, levelStructure: [[0, 1, 1, 1, 0], [1, 1, 1, 0, 0]]),
        LevelItem(id: "level_2", levelNum: 2, levelStructure: [[0, 1, 0, 0, 0, 0],
                                                               [1, 1, 0, 0, 0, 0],
                                                               [0, 1, 1, 0, 0, 0],
                                                               [0, 1, 0, 0, 0, 0],
                                                              ]),
        LevelItem(id: "level_3", levelNum: 3, levelStructure: [[0, 1, 0, 0, 0, 0],
                                                               [0, 1, 1, 1, 0, 0],
                                                               [1, 1, 1, 0, 0, 0],
                                                               [0, 0, 1, 0, 0, 0],
                                                              ]),
        LevelItem(id: "level_4", levelNum: 4, levelStructure: [[1, 0, 0, 0, 0, 0],
                                                               [1, 1, 1, 0, 0, 0],
                                                               [0, 1, 1, 1, 0, 0],
                                                               [0, 1, 0, 0, 0, 0],
                                                              ]),
        LevelItem(id: "level_5", levelNum: 5, levelStructure: [[1, 1, 1, 1, 0, 0],
                                                               [1, 1, 1, 1, 0, 0],
                                                               [0, 0, 1, 1, 0, 0],
                                                              ]),
        LevelItem(id: "level_6", levelNum: 6, levelStructure: [[0, 0, 1, 1, 1, 0],
                                                               [1, 1, 1, 0, 1, 0],
                                                               [1, 0, 1, 1, 1, 0],
                                                               [1, 1, 1, 0, 0, 0],
                                                              ]),
        LevelItem(id: "level_7", levelNum: 7, levelStructure: [[1, 0, 0, 0, 0, 0],
                                                               [1, 1, 1, 1, 0, 0],
                                                               [1, 1, 1, 1, 0, 0],
                                                               [1, 0, 0, 0, 0, 0],
                                                              ]),
        LevelItem(id: "level_8", levelNum: 8, levelStructure: [[1, 0, 0, 0, 0, 0],
                                                               [1, 1, 1, 0, 0, 0],
                                                               [0, 1, 1, 1, 0, 0],
                                                               [0, 1, 0, 0, 0, 0],
                                                              ]),
        LevelItem(id: "level_9", levelNum: 5, levelStructure: [[1, 1, 1, 1, 0, 0],
                                                               [1, 1, 1, 1, 0, 0],
                                                               [0, 0, 1, 1, 0, 0],
                                                              ]),
        LevelItem(id: "level_10", levelNum: 10, levelStructure: [[0, 0, 1, 1, 1, 0],
                                                               [1, 1, 1, 0, 1, 0],
                                                               [1, 0, 1, 1, 1, 0],
                                                               [1, 1, 1, 0, 0, 0],
                                                              ]),
    ]
    @Published var unlockedLevelIds: [String] = []
    
    func obtainLevelsUnlocked() {
        let unlocked = UserDefaults.standard.string(forKey: "available_levels") ?? "level_1,"
        let components = unlocked.components(separatedBy: ",")
        for levelId in components {
            unlockedLevelIds.append(levelId)
        }
    }
    
    func unlockNextLevel(currentLevel: Int) {
        let nextLevelNum = currentLevel + 1
        if nextLevelNum < allLevels.count {
            unlockedLevelIds.append("level_\(nextLevelNum)")
            UserDefaults.standard.set(unlockedLevelIds.joined(separator: ","), forKey: "available_levels")
        }
    }
    
    func nextLevelIsAvailable(currentLevel: Int) -> Bool {
        let nextLevelNum = currentLevel + 1
        if unlockedLevelIds.contains("level_\(currentLevel)") {
            return true
        }
        return false
    }
    
    func getLevelItemByNum(neededLevel: Int) -> LevelItem? {
        if neededLevel > 0 {
            return allLevels.filter { $0.levelNum == neededLevel }[0]
        }
        return nil
    }
    
}

var levelsAllCount = 2
