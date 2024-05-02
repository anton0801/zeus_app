import Foundation

struct LevelItem {
    var id: String
    var levelNum: Int
    var levelStructure: [[Int]] // [[0, 1, 1, 0], [1, 1, 0, 0]] - 1 - exists, 0 - no exists
}
