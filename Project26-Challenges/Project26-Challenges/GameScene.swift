//
//  GameScene.swift
//  Project26
//
//  Created by Christopher Weirup on 2019-06-14.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    let totalLevels = 5
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var currentLevel = 1 {
        didSet {
            if currentLevel <= totalLevels {
                levelLabel.text = "Level: \(currentLevel)"
            }
        }
    }
    
    var isGameOver = false
    
    var mapGrid = [[String]]()
    
    override func didMove(to view: SKView) {
        loadBackground()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.name = "Score"
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.name = "Level"
        levelLabel.text = "Level: 1"
        levelLabel.horizontalAlignmentMode = .right
        levelLabel.position = CGPoint(x: 1000, y: 16)
        levelLabel.zPosition = 2
        addChild(levelLabel)
        
        loadLevel(currentLevel)
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }

    func loadBackground() {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    func loadLevel(_ number: Int) {
        guard let levelURL = Bundle.main.url(forResource: "level\(number)", withExtension: "txt") else {
            fatalError("Could not find level1.txt from the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL).trimmingCharacters(in: .newlines)  else {
            fatalError("Could not load level1.txt from the app bundle.")
        }
        
        // clean out mapGrid
        mapGrid.removeAll(keepingCapacity: true)
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            var mapLine = [String]()
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    // load wall
                    loadWallTile(at: position)
                } else if letter == "v" {
                    // load vortex
                    loadVortexTile(at: position)
                } else if letter == "s" {
                    // load star
                    loadStarTile(at: position)
                } else if letter == "f" {
                    // load finish point
                    loadFinishTile(at: position)
                } else if letter == "t" {
                    // load teleport point
                    loadTeleportTile(at: position)
                } else if letter == " " {
                    // this is an empty space - do nothing!
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
                
                mapLine.append(String(letter))
            }
            // Store each space into mapGrid
            mapGrid.append(mapLine)
        }
    }
    
    func loadWallTile(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.name = "block"
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func loadVortexTile(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadStarTile(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadFinishTile(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadTeleportTile(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleport")
        node.name = "teleport"
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            let scale = SKAction.scale(to: 0.001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([scale, remove])
            
            node.run(sequence)
            score += 1
        } else if node.name == "teleport" {
            // Fade out the marble
            // Find new blank space
            //  Random row (except top and bottom)
            //  Random space that is empty
            // Move marble to empty space and fade in
            let randomRowNumber = Int.random(in: 1..<(mapGrid.count - 1))
            let randomRow = mapGrid[randomRowNumber]
            
            // Create array of indexes of empty spaces
            let spacesInRow = randomRow.indices.filter { randomRow[$0] == " " }
            let randomColumn = spacesInRow.randomElement()!
            
            player.physicsBody?.isDynamic = false
            isGameOver = false
            
            let position = CGPoint(x: (64 * randomColumn) + 32, y: (64 * randomRowNumber) + 32)
            let fadeOut = SKAction.fadeOut(withDuration: 0.25)
            let move = SKAction.move(to: position, duration: 0.25)
            let fadeIn = SKAction.fadeIn(withDuration: 0.25)
            let sequence = SKAction.sequence([fadeOut, move, fadeIn])
            
            // ADJUST THE MOTION!!!
            player.run(sequence) { [weak self] in
                self?.player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self?.player.physicsBody?.isDynamic = true
                self?.isGameOver = false
            }
            
        } else if node.name == "finish" {
            isGameOver = true
            
            // Hide the player
            let scale = SKAction.scale(to: 0.001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([scale, remove])
            
            player.run(sequence)
            
            currentLevel += 1
            if currentLevel > totalLevels {
                // end the game
                // Stop all motion
                isGameOver = true
                scene?.physicsWorld.gravity = .zero
                
                let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
                gameOverLabel.text = "Game Over"
                gameOverLabel.fontSize = 48
                gameOverLabel.horizontalAlignmentMode = .center
                gameOverLabel.position = CGPoint(x: 512, y: 384)
                gameOverLabel.zPosition = 3
                addChild(gameOverLabel)
            } else {
                removeCurrentLevel()
                loadBackground()
                loadLevel(currentLevel)
                createPlayer()
                isGameOver = false
            }
        }
    }
    
    func removeCurrentLevel() {
        // Cycle through all the nodes of the scene and
        // remove all of the nodes we placed
        scene!.enumerateChildNodes(withName: "//*", using: { (node, true) in
            if node.name != "Score" && node.name != "Level" {
                node.removeFromParent()
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
}
