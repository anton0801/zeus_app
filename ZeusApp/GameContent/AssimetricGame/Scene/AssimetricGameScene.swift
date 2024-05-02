import Foundation
import SpriteKit
import SwiftUI

class AssimetricGameScene: SKScene {
    
    var levelsRepository: LevelsRepository!
    
    var level: LevelItem! {
        didSet {
            if levelLabel != nil {
                setUpLevel()
            }
        }
    }
    
    private let tutorText = [
        "PAINT OVER ALL THE\nBLOCKS ON THE FIELD\nTWO COLORS\nSO THAT THE BLOCKS\nARE SEMIMETRIC",
        "YOU CAN USE THE ERASER\nTO REMOVE THE COLOR\nFROM THE BLOCK"
    ]
    
    private var tutorBlackNode: SKSpriteNode!
    private var tutorTextLabel: SKLabelNode!
    
    private var blueColorBtn: SKSpriteNode!
    private var redColorBtn: SKSpriteNode!
    private var eraserColorBtn: SKSpriteNode!
    private var pauseBtn: SKSpriteNode!
    private var clickPreview: SKSpriteNode!
    
    private var arrowBack: SKSpriteNode!
    private var arrowForward: SKSpriteNode!
    private var levelLabel: SKLabelNode!
    
    private var timeLabel: SKLabelNode!
    private var gameTimer: Timer = Timer()
    private var time = 45 {
        didSet {
            var timeS = "\(time)"
            if time <= 9 {
                timeS = "0\(time)"
            }
            timeLabel.text = "00:\(timeS)"
            if time == 0 {
                NotificationCenter.default.post(name: Notification.Name("GAME_LOSE"), object: nil, userInfo: nil)
            }
        }
    }
    
    private var currentTutorIndex = 0
    
    private var eraserMode = false {
        didSet {
            if eraserMode {
                let actionScale = SKAction.scale(to: CGSize(width: 140, height: 110), duration: 0.2)
                eraserColorBtn.run(actionScale)
            } else {
                let actionScale = SKAction.scale(to: CGSize(width: 120, height: 100), duration: 0.2)
                eraserColorBtn.run(actionScale)
            }
        }
    }
    private var selectedColor: ColorType? = nil
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 750, height: 1335)
        addBackImage()
        addGameInterface()
        
        if !UserDefaults.standard.bool(forKey: "not_shown_tutor") {
            drawTutor()
        }
        
        gameTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeMinus), userInfo: nil, repeats: true)
        
        if level == nil {
            level = LevelItem(id: "level_1", levelNum: 1, levelStructure: [[1, 0, 0, 0, 0, 0],
                                                                           [1, 1, 1, 1, 0, 0],
                                                                           [1, 1, 1, 1, 0, 0],
                                                                           [1, 0, 0, 0, 0, 0],
                                                                          ])
        }
        
        setUpLevel()
    }
    
    @objc private func timeMinus() {
        if !isPaused {
            time -= 1
        }
    }
    
    private func drawTutor() {
        tutorBlackNode = SKSpriteNode(color: .black, size: CGSize(width: size.width, height: size.height))
        tutorBlackNode.alpha = 0.6
        tutorBlackNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        tutorBlackNode.zPosition = 5
        addChild(tutorBlackNode)
        
        tutorTextLabel = SKLabelNode(text: tutorText[currentTutorIndex])
        tutorTextLabel.fontName = "Coiny-Regular"
        tutorTextLabel.numberOfLines = 0
        tutorTextLabel.zPosition = 6
        tutorTextLabel.fontSize = 42
        tutorTextLabel.position = CGPoint(x: size.width / 2, y: size.height - 520)
        tutorTextLabel.horizontalAlignmentMode = .center
        addChild(tutorTextLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        let alphaAction = SKAction.fadeAlpha(to: 0.6, duration: 0.1)
        let sequence = SKAction.sequence([fadeInAction, alphaAction])
        tutorBlackNode.run(sequence)
        tutorTextLabel.run(fadeInAction)
        
        if currentTutorIndex == 1 {
            eraserMode = true
            
            eraserColorBtn.zPosition = 6
            clickPreview = SKSpriteNode(imageNamed: "click_preview")
            clickPreview.position = CGPoint(x: eraserColorBtn.position.x, y: eraserColorBtn.position.y - 10)
            clickPreview.zPosition = 7
            addChild(clickPreview)
        }
    }
    
    private func addBackImage() {
        let backImage = SKSpriteNode(imageNamed: "back_image")
        backImage.size = CGSize(width: size.width, height: size.height)
        backImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backImage)
    }
    
    private func addGameInterface() {
        redColorBtn = SKSpriteNode(imageNamed: "red_color")
        redColorBtn.position = CGPoint(x: size.width / 2 - 150, y: 80)
        redColorBtn.name = "red"
        redColorBtn.size = CGSize(width: 120, height: 100)
        addChild(redColorBtn)
        
        blueColorBtn = SKSpriteNode(imageNamed: "blue_color")
        blueColorBtn.position = CGPoint(x: size.width / 2, y: 80)
        blueColorBtn.name = "blue"
        blueColorBtn.size = CGSize(width: 120, height: 100)
        addChild(blueColorBtn)
        
        eraserColorBtn = SKSpriteNode(imageNamed: "eraser")
        eraserColorBtn.position = CGPoint(x: size.width / 2 + 150, y: 80)
        eraserColorBtn.name = "ereser"
        eraserColorBtn.size = CGSize(width: 120, height: 100)
        addChild(eraserColorBtn)
        
        pauseBtn = SKSpriteNode(imageNamed: "ic_pause")
        pauseBtn.position = CGPoint(x: size.width - 70, y: size.height - 80)
        pauseBtn.size = CGSize(width: 80, height: 80)
        addChild(pauseBtn)
        
        let levelBack = SKSpriteNode(imageNamed: "level_back")
        levelBack.position = CGPoint(x: size.width / 2, y: size.height - 150)
        levelBack.size = CGSize(width: 280, height: 60)
        addChild(levelBack)
        
        levelLabel = SKLabelNode(text: "1")
        levelLabel.fontName = "Coiny-Regular"
        levelLabel.fontSize = 42
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height - 165)
        addChild(levelLabel)
        
        arrowBack = SKSpriteNode(imageNamed: "arrow_back")
        arrowBack.position = CGPoint(x: size.width / 2 - 90, y: size.height - 150)
        addChild(arrowBack)
        
        arrowForward = SKSpriteNode(imageNamed: "arrow_forward")
        arrowForward.position = CGPoint(x: size.width / 2 + 90, y: size.height - 150)
        addChild(arrowForward)
        
        timeLabel = SKLabelNode(text: "00:\(time)")
        timeLabel.fontName = "Coiny-Regular"
        timeLabel.fontSize = 72
        timeLabel.position = CGPoint(x: size.width / 2, y: size.height - 280)
        addChild(timeLabel)
    }
    
    private func setUpLevel() {
        levelLabel.text = "\(level.levelNum)"
        if level.levelNum == 1 {
            arrowBack.alpha = 0.6
        }
        if level.levelNum == levelsAllCount {
            arrowForward.alpha = 0.6
        }
        drawGameField()
    }
    
    private var gameField: [[SKSpriteNode?]] = []
    
    private func drawGameField() {
        for (yIndex, row) in level.levelStructure.enumerated() {
            var rowField = [SKSpriteNode?]()
            var rowFieldValues: [Int] = []
            for (index, item) in row.enumerated() {
                if item == 1 {
                    let x = size.width / 1.5 - CGFloat(100 * index)
                    let y = size.height / 2 - CGFloat(yIndex * 85)
                    let node = SKSpriteNode(imageNamed: "rect_clear")
                    node.position = CGPoint(x: x, y: y)
                    node.size = CGSize(width: 100, height: 85)
                    node.name = "shading_\(yIndex)_\(index)"
                    addChild(node)
                    rowField.append(node)
                    rowFieldValues.append(0)
                } else {
                    rowField.append(nil)
                    rowFieldValues.append(-1)
                }
            }
            gameFieldValues.append(rowFieldValues)
            gameField.append(rowField)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        for node in nodes(at: location) {
            if node.name?.contains("shading") == true {
                colorizeGameFieldItem(node)
            }
        }
        
        if tutorBlackNode != nil {
            guard !nodes(at: location).contains(tutorBlackNode) else {
                let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
                if currentTutorIndex == 0 {
                    currentTutorIndex += 1
                    tutorBlackNode.run(fadeOutAction)
                    tutorTextLabel.run(fadeOutAction)
                    drawTutor()
                } else {
                    UserDefaults.standard.set(true, forKey: "not_shown_tutor")
                    tutorBlackNode.run(fadeOutAction) {
                        self.tutorBlackNode.removeFromParent()
                    }
                    tutorTextLabel.run(fadeOutAction) {
                        self.tutorTextLabel.removeFromParent()
                        self.eraserColorBtn.zPosition = 1
                        self.eraserMode = false
                        self.clickPreview.removeFromParent()
                    }
                }
                return
            }
        }
        
        guard !nodes(at: location).contains(pauseBtn) else {
            pauseGame()
            return
        }
        guard !nodes(at: location).contains(blueColorBtn) else {
            selectColor(color: .blue, btn: blueColorBtn)
            return
        }
        guard !nodes(at: location).contains(redColorBtn) else {
            selectColor(color: .red, btn: redColorBtn)
            return
        }
        guard !nodes(at: location).contains(eraserColorBtn) else {
            eraserModeToggle()
            return
        }
        
        guard !nodes(at: location).contains(arrowBack) else {
            let newLevel = levelsRepository.getLevelItemByNum(neededLevel: level.levelNum - 1)
            level = newLevel
            restartGame()
            return
        }
        
        guard !nodes(at: location).contains(arrowForward) else {
            if levelsRepository.nextLevelIsAvailable(currentLevel: level.levelNum) {
                let newLevel = levelsRepository.getLevelItemByNum(neededLevel: level.levelNum + 1)
                level = newLevel
                restartGame()
            }
            return
        }
    }
    
    private func pauseGame() {
        isPaused = true
        NotificationCenter.default.post(name: Notification.Name("GAME_PAUSE"), object: nil, userInfo: nil)
    }
    
    func continuePlay() {
        isPaused = false
    }
    
    func restartGame() -> AssimetricGameScene {
        let newScene = AssimetricGameScene()
        newScene.size = CGSize(width: 750, height: 1335)
        newScene.level = level
        newScene.levelsRepository = levelsRepository
        view!.presentScene(newScene)
        return newScene
    }
    
    private var gameFieldValues: [[Int]] = []
    private let gameFieldColorValues = [
        "rect_blue": 1,
        "rect_red": 2,
        "rect_clear": 0,
    ]
    
    private func colorizeGameFieldItem(_ node: SKNode) {
        var newBlockImage = "rect_blue"
        if selectedColor == .red {
            newBlockImage = "rect_red"
        } else if selectedColor == nil {
            newBlockImage = "rect_clear"
        } else {
            newBlockImage = "rect_blue"
        }
        (node as! SKSpriteNode).texture = SKTexture(imageNamed: newBlockImage)
        let nodeNameComponents = node.name!.components(separatedBy: "_")
        let yIndex = Int(nodeNameComponents[1])!
        let xIndex = Int(nodeNameComponents[2])!
        gameFieldValues[yIndex][xIndex] = gameFieldColorValues[newBlockImage]!
        checkGameField()
    }
    
    func isSymmetric(_ a: [[Int]]) -> Bool {
        var array: [[Int]] = []
        for b in a {
            var row = [Int]()
            for j in b {
                if j != -1 {
                    row.append(j)
                }
            }
            array.append(row)
        }
        
        guard !array.isEmpty else {
            return false
        }
        
        let columnCount = array[0].count
        for row in array {
            if row.count != columnCount {
                return false
            }
        }
        
        let midpoint = columnCount / 2
        
        for row in array {
            for i in 0..<midpoint {
                if row[i] != row[columnCount - 1 - i] {
                    return false
                }
            }
        }
        
        for row in array {
            for i in 0..<row.count {
                if row[i] == 0 {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func checkGameField() {
        var symetric = isSymmetric(gameFieldValues)
        if symetric {
            NotificationCenter.default.post(name: Notification.Name("GAME_WIN"), object: nil, userInfo: nil)
            levelsRepository.unlockNextLevel(currentLevel: level.levelNum)
        }
    }
    
    private func eraserModeToggle() {
        eraserMode = !eraserMode
        selectedColor = nil
        selectColor(color: selectedColor, btn: redColorBtn)
    }
    
    private func selectColor(color: ColorType?, btn: SKSpriteNode) {
        if color == nil {
            let actionScale = SKAction.scale(to: CGSize(width: 120, height: 100), duration: 0.2)
            redColorBtn.run(actionScale)
            blueColorBtn.run(actionScale)
            return
        }
        
        if selectedColor == .red {
            let actionScale = SKAction.scale(to: CGSize(width: 120, height: 100), duration: 0.2)
            redColorBtn.run(actionScale)
        } else if selectedColor == .blue {
            let actionScale = SKAction.scale(to: CGSize(width: 120, height: 100), duration: 0.2)
            blueColorBtn.run(actionScale)
        }
        
        if selectedColor == color {
            let actionScale = SKAction.scale(to: CGSize(width: 120, height: 100), duration: 0.2)
            btn.run(actionScale)
            selectedColor = nil
        } else {
            let actionScale = SKAction.scale(to: CGSize(width: 140, height: 110), duration: 0.2)
            btn.run(actionScale)
            selectedColor = color
        }
        
        eraserMode = false
    }
    
    enum ColorType: String {
        case red = "red"
        case blue = "blue"
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: AssimetricGameScene())
            .ignoresSafeArea()
    }
}
